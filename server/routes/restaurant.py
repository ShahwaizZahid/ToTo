from flask import Blueprint
from controller.restaurant import add_to_cart, get_menu,get_cart_items

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
   