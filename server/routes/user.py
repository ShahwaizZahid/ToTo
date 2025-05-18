from flask import Blueprint
from controller.user import signup , login


auth_routes = Blueprint('auth_routes', __name__)

@auth_routes.route('/signup', methods=['POST'])
def signup_route():
    return signup()

@auth_routes.route('/login', methods=['POST'])
def login_route():
    return login()