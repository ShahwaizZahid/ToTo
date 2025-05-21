from flask import Blueprint, jsonify, request
from config.db import admin_user_collection


admin_auth_routes = Blueprint('admin_auth_routes', __name__)



def admin_login():
    data = request.get_json()
    email = data.get('username')
    password = data.get('password')

    if not email or not password:
        return jsonify({
            "status": "failure",
            "message": "Email and password are required."
        }), 400

    user = admin_user_collection.find_one({"email": email})
    
    if not user:
        return jsonify({
            "status": "failure",
            "message": "Invalid email or password."
        }), 401

    if user['password'] != password:
        return jsonify({
            "status": "failure",
            "message": "Invalid password."
        }), 401

    # Success response
    return jsonify({
        "status": "success",
        "message": "Admin logged in successfully.",
        "data": {
            "userId": str(user["_id"]),
            "email": user["email"],
            "name": user.get("name", "Admin")
        }
    }), 200
