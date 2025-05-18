from flask import Blueprint, jsonify
from config.db import restaurant_collection

menu_routes = Blueprint('menu_routes', __name__)


@menu_routes.route('/menu_list', methods=['GET'])
def get_menu():
    menu_items_cursor = restaurant_collection.find({})
    menu_items = []

    for item in menu_items_cursor:
        item['_id'] = str(item['_id'])  # Convert ObjectId to string
        menu_items.append(item)

    return jsonify(menu_items), 200
