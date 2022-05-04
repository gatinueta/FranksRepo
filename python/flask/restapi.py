from flask import Flask, jsonify, request
from flask_restful import Resource, Api
from time import sleep
import threading
import sys

app = Flask(__name__)
api = Api(app)

class HelloWorld(Resource):
    def get(self):
        return {'hello': 'world'}

class KontakteTelefon(Resource):
    def get(self):
            return {'kontakte':'telefon'}
    def post(self):
            print(threading.get_ident(), ": received request.", file=sys.stderr, flush=True);
            sleep(2)
            print(threading.get_ident(), ": returning response.", file=sys.stderr, flush=True);
            return {'kontakte-telefon': 'POST'}

gid = 1

@app.route('/kontakte/attachments', methods=['POST'])
def store_attachment():
    reqdata = request.json;
    global gid
    attid = "attachment{}".format(gid)
    gid += 1
    reqdata['id'] = attid
    print('storing ', reqdata, file=sys.stderr, flush=True);
    return attid

api.add_resource(HelloWorld, '/')
api.add_resource(KontakteTelefon, '/kontakte/telefon')

if __name__ == '__main__':
    app.run(debug=True)

# curl -X POST -H "Content-Type: application/json" -d '{"data": "SGVsbG8gd29ybGQ=","name": "Preisblatt.pdf","mimeType": "application/pdf"}' http://localhost:5000/kontakte/attachments