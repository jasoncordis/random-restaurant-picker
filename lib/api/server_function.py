import random
import requests
import time

yelp_graphql_endpoint: str = 'https://api.yelp.com/v3/graphql'
yelp_rest_endpoint: str = 'https://api.yelp.com/v3/businesses/search'
yelp_auth_headers: dict = {
    'Authorization': 'Bearer ' + 'RU8br-ZfI6fTPcol68ahMsStdnsyl2CDcHneoscds5N9wS1bq0CVX0hff0IrgL9cZaIGpwjCK5wNSTqo5pLVj1DdUm5_jCkPx3NqXysqCQjEC2J6kvr8pjWOGfBUYHYx'
}


def get_1_restaurant_q(location, offset) -> str:
    return (
        'query {\n'
            'search(\n'
            'term: "restaurants",\n'
            f'location: "{location}",\n'
            'limit: 1,\n'
            f'offset: {offset}\n'
            ') {\n'
                'business {\n'
                    'name\n'
                    'url\n'
                    'photos\n'
                    'is_closed\n'
                    'location {\n'
                    'formatted_address\n'
                    '}\n'
                    'reviews {\n'
                    'text\n'
                    '}\n'
                '}\n'
            '}\n'
        '}\n'
    )


def get_total_restaurants_q(location) -> str:
    return (
        'query {\n'
            'search(\n'
                'term: "restaurants",\n'
                f'location: "{location}",\n'
                'limit: 1\n'
            ') {\n'
                'total\n'
            '}\n'
        '}\n'
    )


def graphql_query(uri: str, query: str, status_code: int, headers: dict):
    request = None
    for _ in range(29):
        request = requests.post(uri, json={'query': query}, headers=headers)
        if (
            request.status_code == status_code and
            'errors' not in request.json()
        ):
            return request.json()
        elif (
            'errors' in request.json() and
            request.json()['errors'][0]['extensions']['code'] == 'INTERNAL_ERROR'
        ):
            print(request.json())
            time.sleep(3)
    raise Exception(f"Unexpected status code returned: {request.status_code}")


def get_query(uri: str, params: dict, status_code: int, headers: dict):
    request = None
    for _ in range(29):
        request = requests.get(uri, params=params, headers=headers)
        if (
            request.status_code == status_code and
            'errors' not in request.json()
        ):
            return request.json()
        elif (
            'errors' in request.json() and
            request.json()['errors'][0]['extensions']['code'] == 'INTERNAL_ERROR'
        ):
            print(request.json())
            time.sleep(3)
    raise Exception(f"Unexpected status code returned: {request.status_code}")


def get_random_business(request):
    """Responds to any HTTP request.
    Args:
        request (flask.Request): HTTP request object.
    Returns:
        The response text or any set of values that can be turned into a
        Response object using
        `make_response <http://flask.pocoo.org/docs/1.0/api/#flask.Flask.make_response>`.
    """
    ## Set CORS headers for the preflight request
    if request.method == 'OPTIONS':
        ## Allows GET requests from any origin with the Content-Type
        headers = {
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': 'GET',
            'Access-Control-Allow-Headers': 'Content-Type',
            'Access-Control-Max-Age': '3600'
        }
        return ('', 204, headers)

    location = None
    request_json = request.get_json()
    if request.args and 'message' in request.args:
        location = request.args.get('location')
    elif request_json or 'message' in request_json:
        location = request.json['location']

    total_businesses = graphql_query(
        uri=yelp_graphql_endpoint,
        query=get_total_restaurants_q(location),
        status_code=200,
        headers=yelp_auth_headers
    )['data']['search']['total']
    random.seed()
    # Looks like yelp doesn't let us set too high of an offset. 999 seems to be the max.
    random_offset = min(random.randrange(0, total_businesses), random.randrange(0, 999))
    # print(random_offset)

    ## Set CORS headers for the main request
    headers = {
        'Access-Control-Allow-Origin': '*'
    }

    return (
        graphql_query(
            uri=yelp_graphql_endpoint,
            query=get_1_restaurant_q(location, offset=random_offset),
            status_code=200,
            headers=yelp_auth_headers
        ), 200, headers
    )


# location = "San Francisco, CA, USA"
# total_businesses = graphql_query(
#         uri=yelp_graphql_endpoint,
#         query=get_total_restaurants_q(location),
#         status_code=200,
#         headers=yelp_auth_headers
#     )['data']['search']['total']
# random.seed()
# print(random_offset)
# print(get_query(
#         uri=yelp_rest_endpoint,
#         params={
#             'location': location,
#             'categories': 'restaurant',
#             'limit': 1,
#             'offset': random_offset,
#             'open_now': True,
#         },
#         status_code=200,
#         headers=yelp_auth_headers
# ))

# print('\nsecond')
# print(get_random_business(''))
