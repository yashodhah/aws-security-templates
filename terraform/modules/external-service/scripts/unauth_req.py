import os
import requests

def call_api():
    url = os.environ.get('URL')
    response = requests.get(url)

    print("HTTP status code:", response.status_code)
    print("Response body:", response.text)


call_api()
