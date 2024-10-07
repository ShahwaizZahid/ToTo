from flask import Flask, jsonify, request
from flask_pymongo import PyMongo
from pymongo.errors import ServerSelectionTimeoutError
from urllib.parse import quote_plus
from pymongo import MongoClient
import re
# URL-encode the username and password for MongoDB Atlas connection
username = "shahwaizmughal"
password = "S@n9h6AQy2rWBAr"
encoded_username = quote_plus(username)
encoded_password = quote_plus(password)

app = Flask(__name__)

# Use the encoded username and password in the MongoDB connection URI
client = MongoClient(f"mongodb+srv://{encoded_username}:{encoded_password}@cluster0.gjubc.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0")

db = client['ToTo']
collection = db['users']
document = {"name": 'Shahwaiazadaddad', "email": "shahwaiz", "password": '123456'}

@app.route('/')
def check_mongo_connection():
    try:
        insert_doc = collection.insert_one(document)
        return jsonify({"status": "success", "message": 'Successfully inserted'}), 200
    except ServerSelectionTimeoutError as e:
        # Catch the connection timeout error and return failure response
        return jsonify({"status": "failure", "message": "Failed to insert.", "error": str(e)}), 500





# Function to validate email format
def is_valid_email(email):
    # Simple regex pattern for validating an email address
    email_regex = r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$'
    return re.match(email_regex, email)

@app.route('/sig', methods=['POST'])
def signup():
    data = request.get_json()
    print(data)
    username = data.get('username')
    email = data.get('email')
    password = data.get('password')

    # Check if all fields are provided
    if not username or not email or not password:
        return jsonify({"status": "failure", "message": "All fields (username, email, password) are required."}), 400

    # Validate email format
    if not is_valid_email(email):
        return jsonify({"status": "failure", "message": "Invalid email format."}), 400

    # Check if email is unique
    existing_user = collection.find_one({"email": email})
    if existing_user:
        return jsonify({"status": "failure", "message": "Email already exists."}), 409  # Conflict

    # Insert the new user into the database
    document = {"username": username, "email": email, "password": password}  # Note: Password should be hashed

    try:
        collection.insert_one(document)
        return jsonify({"status": "success", "message": "User registered successfully."}), 201
    except ServerSelectionTimeoutError as e:
        return jsonify({"status": "failure", "message": "Failed to insert.", "error": str(e)}), 500


if __name__ == '__main__':
    app.run(debug=True)
