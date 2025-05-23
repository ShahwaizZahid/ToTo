from flask import Blueprint,jsonify,request
from controller.restaurant import add_to_cart, get_menu,get_cart_items, update_cart_count, clear_cart
from config.db import orders_collection
import datetime


menu_routes = Blueprint('menu_routes', __name__)


@menu_routes.route('/menu_list', methods=['GET'])
def get_menu_route():
    return get_menu()
   

@menu_routes.route('/add_to_cart', methods=['POST'])
def add_to_cart_route():
    return add_to_cart()


@menu_routes.route('/get_cart_items', methods=['GET'])
def get_cart_items_route():
    return get_cart_items()
   

@menu_routes.route('/cart/update_count', methods=['POST'])
def update_cart_count_route():
    return update_cart_count()
    


@menu_routes.route('/clear_cart', methods=['POST'])
def clear_cart_route():
     return clear_cart()



# api/orders.py



@menu_routes.route('/api/orders', methods=['POST'])
def create_order():
    data = request.get_json()

    if not data:
        return jsonify({"error": "No data provided"}), 400

    # Optional: Add a timestamp
    data['timestamp'] = datetime.datetime.utcnow()
    data['orderStatus'] = "Pending"
    try:
        result = orders_collection.insert_one(data)
        return jsonify({
            "message": "Order successfully placed",
            "order_id": str(result.inserted_id)
        }), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500
