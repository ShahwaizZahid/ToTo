
from flask import Blueprint
from flask import  jsonify,request
from flask import Blueprint, jsonify, request
from config.db import restaurant_collection
from upload_images import upload_image_to_cloudinary
admin_restaurant_routes = Blueprint('admin_restaurant_routes', __name__)

import base64
import tempfile

def add_food():
    data = request.get_json()

    name = data.get('name')
    description = data.get('description')
    category = data.get('category')
    price = data.get('price')
    base64_image = data.get('image')
    addons = data.get('addons', [])

    # Basic validation
    if not name or not description or not category or not price or not base64_image or not addons:
        return jsonify({
            "status": "failure",
            "message": "Please provide all required fields."
        }), 400

    try:
        # Decode base64 image and write to temp file
        image_bytes = base64.b64decode(base64_image)
        with tempfile.NamedTemporaryFile(delete=False, suffix=".jpg") as tmp:
            tmp.write(image_bytes)
            tmp_path = tmp.name

        # Upload to Cloudinary
        uploaded_url = upload_image_to_cloudinary(tmp_path)

        if not uploaded_url:
            return jsonify({"status": "failure", "message": "Image upload failed"}), 500

    except Exception as e:
        print(f"Image decoding or upload failed: {e}")
        return jsonify({"status": "failure", "message": "Invalid image data"}), 400

    # Insert into MongoDB
    food_doc = {
        "name": name,
        "description": description,
        "category": category,
        "price": float(price),
        "image": uploaded_url,
        "addons": addons
    }

    result = restaurant_collection.insert_one(food_doc)

    return jsonify({
        "status": "success",
        "message": "Food item added successfully.",
        "foodId": str(result.inserted_id)
    }), 201
