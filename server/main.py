from flask import Flask
from routes.user import auth_routes
from config.db import check_mongo_connection

app = Flask(__name__)
app.register_blueprint(auth_routes) 

check_mongo_connection() 
print (" Pyhton Server is running successfully")


if __name__ == '__main__':
    app.run(debug=True)  