import base64
import tempfile
from bson import ObjectId
from flask import Blueprint, jsonify, request

from config.db import restaurant_collection, user_collection,orders_collection
from upload_images import upload_image_to_cloudinary

admin_restaurant_routes = Blueprint('admin_restaurant_routes', __name__)



# ----------------------------
#    Add New Food
# ----------------------------
def add_food():
    data = request.get_json()

    name = data.get('name')
    description = data.get('description')
    category = data.get('category')
    price = data.get('price')
    base64_image = data.get('image')
    addons = data.get('addons', [])

    # Basic validation
    if not name or not description or not category or not price or not base64_image or not addons:
        return jsonify({
            "status": "failure",
            "message": "Please provide all required fields."
        }), 400

    try:
        # Decode base64 image and write to temp file
        image_bytes = base64.b64decode(base64_image)
        with tempfile.NamedTemporaryFile(delete=False, suffix=".jpg") as tmp:
            tmp.write(image_bytes)
            tmp_path = tmp.name

        # Upload to Cloudinary
        uploaded_url = upload_image_to_cloudinary(tmp_path)

        if not uploaded_url:
            return jsonify({"status": "failure", "message": "Image upload failed"}), 500

    except Exception as e:
        print(f"Image decoding or upload failed: {e}")
        return jsonify({"status": "failure", "message": "Invalid image data"}), 400

    # Insert into MongoDB
    food_doc = {
        "name": name,
        "description": description,
        "category": category,
        "price": float(price),
        "image": uploaded_url,
        "addons": addons
    }

    result = restaurant_collection.insert_one(food_doc)

    return jsonify({
        "status": "success",
        "message": "Food item added successfully.",
        "foodId": str(result.inserted_id)
    }), 201


# ----------------------------
#    Delete  Food
# ----------------------------
def delete_food(food_id):
    try:
        result = restaurant_collection.delete_one({'_id': ObjectId(food_id)})

        if result.deleted_count == 1:
            return jsonify({
                "status": "success",
                "message": "Food item deleted successfully."
            }), 200
        else:
            return jsonify({
                "status": "failure",
                "message": "Food item not found."
            }), 404

    except Exception as e:
        return jsonify({
            "status": "error",
            "message": "Invalid ID or server error."
        }), 500  


# ----------------------------
#    Get All Users
# ----------------------------
def get_all_users():
    try:
        users_cursor = user_collection.find()
        users = []

        for user in users_cursor:
            users.append({
                "_id": str(user.get("_id")),
                "email": user.get("email"),
                "password": user.get("password")
            })

        return jsonify({
            "status": "success",
            "users": users,
            'length': len(users)
        }), 200

    except Exception as e:
        return jsonify({
            "status": "error",
            "message": "Failed to retrieve users."
        }), 500    
    

# ----------------------------
#    Delete User
# ----------------------------
def delete_user(user_id):
    try:
        result = user_collection.delete_one({'_id': ObjectId(user_id)})

        if result.deleted_count == 1:
            return jsonify({
                'status': 'success',
                'message': 'User deleted successfully.'
            }), 200
        else:
            return jsonify({
                'status': 'failure',
                'message': 'User not found.'
            }), 404
    except Exception as e:
        return jsonify({
            'status': 'error',
            'message': f'Error deleting user: {str(e)}'
        }), 500


# ----------------------------
#   Make irder Success
# ----------------------------
def mark_order_success(order_id):
    try:
        result = orders_collection.update_one(
            {"_id": ObjectId(order_id)},
            {"$set": {"orderStatus": "Success"}}
        )

        if result.matched_count == 0:
            return jsonify({"message": "Order not found"}), 404

        return jsonify({"message": "Order marked as Success"}), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500