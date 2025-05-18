from flask import Blueprint, jsonify, request
from controller.user import signup 


auth_routes = Blueprint('auth_routes', __name__)

@auth_routes.route('/signup', methods=['POST'])
def signup_route():
    return signup()