from services.user import is_valid_email
from flask import Flask, jsonify, request
from config.db import user_collection as collection
from pymongo.errors import ServerSelectionTimeoutError



def signup():
    data = request.get_json()
    print(data)
    email = data.get('email')
    password = data.get('password')

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
