
from bson import ObjectId
from flask import Blueprint
from controller.admin_restaurant import add_food,delete_food, get_all_users, delete_user, mark_order_success
from flask import  jsonify,request
from flask import Blueprint, jsonify, request
from config.db import restaurant_collection, user_collection,orders_collection
admin_restaurant_routes = Blueprint('admin_restaurant_routes', __name__)

@admin_restaurant_routes.route('/api/admin/food/add', methods=['POST'])
def add_food_rote():
    return add_food()
  

@admin_restaurant_routes.route('/api/admin/food/delete/<string:food_id>', methods=['DELETE'])
def delete_food_route(food_id):
    return delete_food(food_id)

@admin_restaurant_routes.route('/api/admin/users', methods=['GET'])
def get_all_users_route():
    return get_all_users()

@admin_restaurant_routes.route('/api/admin/user/delete/<user_id>', methods=['DELETE'])
def delete_user_route(user_id):
    return delete_user(user_id)
    


@admin_restaurant_routes.route('/api/mark_order_success/<order_id>', methods=['PUT'])
def mark_order_success_route(order_id):
    return mark_order_success(order_id)
    