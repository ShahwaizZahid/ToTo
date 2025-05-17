from pymongo import MongoClient
from urllib.parse import quote_plus

username = "shahwaizmughal"
password = "S@n9h6AQy2rWBAr"

encoded_username = quote_plus(username)
encoded_password = quote_plus(password)

uri = f"mongodb+srv://{encoded_username}:{encoded_password}@cluster0.gjubc.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0"

client = MongoClient(uri)

db = client['ToTo']
user_collection = db['users']


def check_mongo_connection():
    try:
        client.admin.command('ismaster')
        print("MongoDB is connected successfully.")
    except Exception as e:
        print(f"Failed to connect to MongoDB: {e}")
