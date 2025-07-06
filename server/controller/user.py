from services.user import is_valid_email
from flask import  jsonify, request
from config.db import user_collection as collection
from pymongo.errors import ServerSelectionTimeoutError


# ----------------------------
#   User Registered
# ----------------------------
def signup():
    data = request.get_json()
    email = data.get('email')
    password = data.get('password')


    print('as')

    # Check if all fields are provided
    if  not email or not password:
        return jsonify({"status": "failure", "message": "All fields (username, email, password) are required."}), 400

    # Validate email format
    if not is_valid_email(email):
        return jsonify({"status": "failure", "message": "Invalid email format."}), 400

    # Check if email is unique
    existing_user = collection.find_one({"email": email})
    if existing_user:
        return jsonify({"status": "failure", "message": "Email already exists."}), 409  # Conflict

    # Insert the new user into the database
    document = {"email": email, "password": password}  # Note: Password should be hashed

    try:
        collection.insert_one(document)
        return jsonify({"status": "success", "message": "User registered successfully."}), 201
    except ServerSelectionTimeoutError as e:
        return jsonify({"status": "failure", "message": "Failed to insert.", "error": str(e)}), 500


# ----------------------------
#    User Login
# ----------------------------
def login():
    data = request.get_json()
    email = data.get('email')
    password = data.get('password')

    if not email or not password:
        return jsonify({"status": "failure", "message": "Email and password are required."}), 400

    user = collection.find_one({"email": email})
    if not user:
        return jsonify({"status": "failure", "message": "Invalid email or password."}), 401

    if user['password'] != password:
        return jsonify({"status": "failure", "message": "Invalid password."}), 401

    return jsonify({
        "status": "success",
        "message": "Login successful",
        "email": email,
        "userId": str(user["_id"])  # convert ObjectId to string for JSON
    }), 201
