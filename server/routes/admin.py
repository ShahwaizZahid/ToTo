from flask import Blueprint, jsonify, request
from config.db import admin_user_collection
from controller.admin import admin_login

admin_auth_routes = Blueprint('admin_auth_routes', __name__)


@admin_auth_routes.route('/admin/login', methods=['POST'])
def admin_login_route():
    return admin_login()