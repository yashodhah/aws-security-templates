import requests
import os

client_id = os.environ.get('CLIENT_ID')
client_secret = os.environ.get('CLIENT_SECRET')
# scope = os.environ.get('SCOPE')
token_endpoint = os.environ.get('TOKEN_ENDPOINT')

headers = {
    "Content-Type": "application/x-www-form-urlencoded"
}

data = {
    "grant_type": "client_credentials",
    "client_id": client_id,
    "client_secret": client_secret
    # "scope": scope
}

response = requests.post(token_endpoint, headers=headers, data=data)

if response.status_code == 200:
    access_token = response.json()['access_token']
    print("Access token:", access_token)
else:
    print("Error getting access token:", response.text)

# Use the access token in the Authorization header to call another endpoint
endpoint_url = os.environ.get('URL')
headers = {
    "Authorization": f"Bearer {access_token}"
}

response = requests.post(endpoint_url, headers=headers)

print("HTTP status code:", response.status_code)
print("Response body:", response.text)

