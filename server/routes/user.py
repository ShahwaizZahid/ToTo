from flask import Blueprint,  request
from controller.user import signup 


auth_routes = Blueprint('auth_routes', __name__)

@auth_routes.route('/sig', methods=['POST'])
def signup_route():
    return signup()
