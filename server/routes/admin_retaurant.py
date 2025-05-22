
from bson import ObjectId
from flask import Blueprint
from controller.admin_restaurant import add_food
from flask import  jsonify,request
from flask import Blueprint, jsonify, request
from config.db import restaurant_collection, user_collection
admin_restaurant_routes = Blueprint('admin_restaurant_routes', __name__)

@admin_restaurant_routes.route('/api/admin/food/add', methods=['POST'])
def add_food_rote():
    return add_food()
  

@admin_restaurant_routes.route('/api/admin/food/delete/<string:food_id>', methods=['DELETE'])
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
        print(f"Error deleting food item: {e}")
        return jsonify({
            "status": "error",
            "message": "Invalid ID or server error."
        }), 500  


@admin_restaurant_routes.route('/api/admin/users', methods=['GET'])
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
            "users": users
        }), 200

    except Exception as e:
        return jsonify({
            "status": "error",
            "message": "Failed to retrieve users."
        }), 500        