from flask import Flask
from flask_cors import CORS
from routes.restaurant import menu_routes
from routes.user import auth_routes
from routes.admin import admin_auth_routes
from routes.admin_retaurant import admin_restaurant_routes
from config.db import check_mongo_connection

app = Flask(__name__)
CORS(app)

# Register blueprints
app.register_blueprint(auth_routes) 
app.register_blueprint(menu_routes)
app.register_blueprint(admin_auth_routes)
app.register_blueprint(admin_restaurant_routes)

# Check DB connection
check_mongo_connection()
print("Python Server is running successfully")

# Root route
@app.route("/", methods=["GET"])
def hello():
    return {"message": "Hello, Python!"}

