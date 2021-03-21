import json
import requests

address = "San Francisco, CA, USA"
print(requests.post(
    'https://us-central1-packhacks-random-restaurant.cloudfunctions.net/get-yelp-random-business',
    data=json.dumps({'location': address}),
    headers={'content-type': 'application/json'}
))
