from flask import Flask, jsonify
from werkzeug.middleware.proxy_fix import ProxyFix

app = Flask(__name__)
app.wsgi_app = ProxyFix(app.wsgi_app)

@app.route("/")
def hello():
    return jsonify({"message": "Hello World from Flask on Vercel!"})

def handler(environ, start_response):
    # This handler is called by Vercel
    return app(environ, start_response)
