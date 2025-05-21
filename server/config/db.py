from flask import json
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
restaurant_collection = db['RestaurantList']
add_cart_items = db['add_cart_items']
admin_user_collection = db['admin_users']

def check_mongo_connection():
    try:
        client.admin.command('ismaster')
        print("MongoDB is connected successfully.")
    except Exception as e:
        print(f"Failed to connect to MongoDB: {e}")


def insert_menu_from_file(json_file_path):
    """
    Reads a JSON file with an array of menu items and inserts them into the 'RestaurantList' collection.

    Args:
        json_file_path (str): Path to the JSON file containing the menu array.

    Returns:
        inserted_ids (list): List of ObjectIds for the inserted documents.
    """
    try:
        with open(json_file_path, 'r') as file:
            menu_array = json.load(file)
        
        if not isinstance(menu_array, list):
            print("JSON file does not contain a list.")
            return None
        
        result = restaurant_collection.insert_many(menu_array)
        print(f"Inserted {len(result.inserted_ids)} menu items.")
        return result.inserted_ids
    except Exception as e:
        print(f"Error inserting menus from file: {e}")
        return None
    

# insert_menu_from_file('../restaurantList.json')

