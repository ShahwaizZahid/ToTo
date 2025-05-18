from flask import Flask
from routes.user import auth_routes
from config.db import check_mongo_connection
from flask_cors import CORS

app = Flask(__name__)
CORS(app)
app.register_blueprint(auth_routes) 

check_mongo_connection() 
print (" Pyhton Server is running successfully")


if __name__ == '__main__':
     app.run(host="0.0.0.0", port=5001, debug=True)