
from bson import ObjectId
from flask import Blueprint
from controller.admin_restaurant import add_food
from flask import Blueprint
from flask import  jsonify,request
from flask import Blueprint, jsonify, request
from config.db import restaurant_collection
from upload_images import upload_image_to_cloudinary
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