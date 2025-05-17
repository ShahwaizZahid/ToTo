from pymongo import MongoClient
from urllib.parse import quote_plus
from dotenv import load_dotenv
import os

load_dotenv()

username = quote_plus(os.getenv("MONGO_USER"))
password = quote_plus(os.getenv("MONGO_PASSWORD"))
cluster = os.getenv("MONGO_CLUSTER")
db_name = os.getenv("MONGO_DB_NAME")

uri = f"mongodb+srv://{username}:{password}@{cluster}/?retryWrites=true&w=majority&appName=Cluster0"

client = MongoClient(uri)
db = client[db_name]
user_collection = db['users']


def check_mongo_connection():
    try:
        client.admin.command('ismaster')
        print("MongoDB is connected successfully.")
    except Exception as e:
        print(f"Failed to connect to MongoDB: {e}")
