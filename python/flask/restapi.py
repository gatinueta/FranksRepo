from flask import Flask, jsonify, request
from flask_restful import Resource, Api
from time import sleep
import threading
import sys

app = Flask(__name__)
api = Api(app)

@app.route('/', methods=['POST'])
def call_post():
	reqdata = request.json
	return { 'message': 'thanks for passing reqdata', 'reqdata': reqdata }

if __name__ == '__main__':
    app.run(debug=True)

# curl -X POST -H "Content-Type: application/json" -d '{"data": "SGVsbG8gd29ybGQ=","name": "Preisblatt.pdf","mimeType": "application/pdf"}' http://localhost:5000/
