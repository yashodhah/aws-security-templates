import requests
import os

def get_access_token():
    client_id = os.environ.get('CLIENT_ID')
    client_secret = os.environ.get('CLIENT_SECRET')
    scope = os.environ.get('SCOPE')
    token_endpoint = os.environ.get('TOKEN_ENDPOINT')

    print("Getting an access token from :", token_endpoint)

    headers = {
        "Content-Type": "application/x-www-form-urlencoded"
    }

    data = {
        "grant_type": "client_credentials",
        "client_id": client_id,
        "client_secret": client_secret,
        "scope": scope
    }

    response = requests.post(token_endpoint, headers=headers, data=data)

    if response.status_code == 200:
        access_token = response.json()['access_token']
        print("Access token :", access_token)

        return access_token
    else:
        print("Error getting access token:", response.text)
        return None


def call_api():
    endpoint_url = os.environ.get('URL')
    access_token = get_access_token()

    if access_token:
        headers = {
            "Authorization": f"Bearer {access_token}"
        }

        response = requests.post(endpoint_url, headers=headers)

        print("HTTP status code:", response.status_code)
        print("Response body:", response.text)


call_api()