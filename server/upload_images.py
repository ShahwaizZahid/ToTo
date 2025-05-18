import cloudinary
import cloudinary.uploader

import os
from dotenv import load_dotenv

load_dotenv()  # Load variables from .env file

cloudinary.config(
    cloud_name=os.getenv('CLOUDINARY_CLOUD_NAME'),
    api_key=os.getenv('CLOUDINARY_API_KEY'),
    api_secret=os.getenv('CLOUDINARY_API_SECRET'),
    secure=True
)


def upload_image_to_cloudinary(image_path):
    try:
        response = cloudinary.uploader.upload(image_path)
        # The uploaded image URL
        url = response.get('secure_url')
        print(url)
        return url
    except Exception as e:
        print(f"Error uploading image: {e}")
        return None
    

upload_image_to_cloudinary('assets/images/burgers/egg_burger.jpeg')