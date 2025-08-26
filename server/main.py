from flask import Flask
from flask_cors import CORS
from routes.restaurant import menu_routes
from routes.user import auth_routes
from routes.admin import admin_auth_routes
from routes.admin_retaurant import admin_restaurant_routes
from config.db import check_mongo_connection

app = Flask(__name__)
CORS(app)
app.register_blueprint(auth_routes) 
app.register_blueprint(menu_routes)
app.register_blueprint(admin_auth_routes)
app.register_blueprint(admin_restaurant_routes)

check_mongo_connection() 
print (" Pyhton Server is running successfully")

@app.route("/", methods=["GET"])
def hello():
    return {"message": "Hello, Python!"}


if __name__ == '__main__':
     app.run(host="0.0.0.0", port=5001, debug=True)