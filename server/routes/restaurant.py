from flask import Blueprint, jsonify,request
from config.db import restaurant_collection, add_cart_items

menu_routes = Blueprint('menu_routes', __name__)


@menu_routes.route('/menu_list', methods=['GET'])
def get_menu():
    menu_items_cursor = restaurant_collection.find({})
    menu_items = []

    for item in menu_items_cursor:
        item['_id'] = str(item['_id'])  # Convert ObjectId to string
        menu_items.append(item)

    return jsonify(menu_items), 200


@menu_routes.route('/add_to_cart', methods=['POST'])
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
