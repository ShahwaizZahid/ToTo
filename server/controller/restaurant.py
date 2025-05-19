from flask import  jsonify,request
from config.db import restaurant_collection, add_cart_items
from bson import ObjectId



# ----------------------------
#    Get All menu
# ----------------------------
def get_menu():
    menu_items_cursor = restaurant_collection.find({})
    menu_items = []

    for item in menu_items_cursor:
        item['_id'] = str(item['_id'])  # Convert ObjectId to string
        menu_items.append(item)

    return jsonify(menu_items), 200


# ----------------------------
#    Add item in Cart
# ----------------------------
def add_to_cart():
    data = request.json

    try:
        user_id = data['userId']
        food_id = data['foodId']
        addons = data.get('addons', [])

        # Ensure addons list is sorted for consistent matching
        sorted_addons = sorted(addons)

        # Check if this exact item already exists
        existing_item = add_cart_items.find_one({
            'userId': user_id,
            'foodId': food_id,
            'addons': sorted_addons
        })

        if existing_item:
            # Update count
            add_cart_items.update_one(
                {'_id': existing_item['_id']},
                {'$inc': {'count': 1}}
            )
            return jsonify({'message': 'Item already in cart, count incremented'}), 200
        else:
            # Add new item with count = 1
            cart_item = {
                'userId': user_id,
                'foodId': food_id,
                'addons': sorted_addons,
                'count': 1
            }
            add_cart_items.insert_one(cart_item)
            return jsonify({'message': 'Item added to cart successfully'}), 200

    except Exception as e:
        print('Error:', e)
        return jsonify({'error': 'Failed to add item to cart'}), 500
    

# ----------------------------
#    Get Cart Items
# ----------------------------
def get_cart_items():
    try:
        user_id = request.args.get('userId')
        if not user_id:
            return jsonify({'error': 'Missing userId'}), 400

        items_cursor = add_cart_items.find({'userId': user_id})
        cart_items = []

        for item in items_cursor:
            food_item = restaurant_collection.find_one({'_id': ObjectId(item['foodId'])})
            if not food_item:
                continue

            selected_addon_names = item.get('addons', [])  # list of selected addon names

            # Filter only the selected addons with name and price
            selected_addons = [
                {
                    'name': addon['name'],
                    'price': addon['price']
                }
                for addon in food_item.get('availableAddons', [])
                if addon['name'] in selected_addon_names
            ]

            cart_items.append({
                'cartItemId': str(item['_id']),
                'imagePath': food_item.get('imagePath', ''),
                'name': food_item.get('name', ''),
                'price': food_item.get('price', 0),
                'count': item.get('count', 1),
                'addons': selected_addons,
            })
        
        return jsonify(cart_items), 200

    except Exception as e:
        print('Error:', e)
        return jsonify({'error': 'Failed to fetch cart items'}), 500


# ----------------------------
#    Update counter in cart
# ----------------------------
def update_cart_count():
    data = request.json
    cart_id = data.get('cart_id')
    method = data.get('method')  # 'increment' or 'decrement'

    if not cart_id or method not in ['increment', 'decrement']:
        return jsonify({"error": "Invalid input"}), 400

    try:
        cart_obj_id = ObjectId(cart_id)   # <-- convert string to ObjectId
    except Exception:
        return jsonify({"error": "Invalid cart_id"}), 400

    # Now query by ObjectId
    item = add_cart_items.find_one({"_id": cart_obj_id})
    if not item:
        return jsonify({"error": "Cart item not found"}), 404

    current_count = item.get('count', 1)

    if method == 'increment':
        new_count = current_count + 1
        add_cart_items.update_one({"_id": cart_obj_id}, {"$set": {"count": new_count}})
        return jsonify({"message": "Count incremented", "count": new_count}), 200

    elif method == 'decrement':
        new_count = current_count - 1
        if new_count < 1:
            add_cart_items.delete_one({"_id": cart_obj_id})
            return jsonify({"message": "Item removed from cart"}), 200
        else:
            add_cart_items.update_one({"_id": cart_obj_id}, {"$set": {"count": new_count}})
            return jsonify({"message": "Count decremented", "count": new_count}), 200

