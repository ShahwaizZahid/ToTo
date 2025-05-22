
from flask import Blueprint
from controller.admin_restaurant import add_food

admin_restaurant_routes = Blueprint('admin_restaurant_routes', __name__)

@admin_restaurant_routes.route('/api/admin/food/add', methods=['POST'])
def add_food_rote():
    return add_food()
  