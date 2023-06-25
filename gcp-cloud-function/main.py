import os
import json
import requests

# Set runtime environment variables in GCP Cloud Function settings 
github_token = os.environ.get('GITHUB_TOKEN')
github_user = os.environ.get('GITHUB_USER')
github_repo = os.environ.get('GITHUB_REPO')

def webhook_function(event: dict, unused_context: None) -> str:

    event_type = event["attributes"]["eventType"]
    url = f"https://api.github.com/repos/{github_user}/{github_repo}/dispatches"
    data = {
        'event_type': 'update-secret'
    }
    headers = {
         "Accept": "application/vnd.github+json",
         "Authorization": f"Bearer {github_token}",
         "X-GitHub-Api-Version": "2022-11-28"
    }
    if event_type == "SECRET_VERSION_ADD":
        r = requests.post(url, data=json.dumps(data), headers=headers)
        print(f"r = {r}")
        if r.status_code == 204:
            print("Webhook triggered successfully")
            return ('OK', r.status_code)
        else:
            print(f"Failed to trigger webhook with response code: {r.status_code}")
            return ('Failed', r.status_code)
    print("Ignoring not SECRET_UPDATE event")
    return "Ignoring not SECRET_UPDATE event"