import json

def lambda_handler(event, context):
    response = {
        "message": "Hello from AWS Rohit!",
        "status": "success"
    }

    return {
        "statusCode": 200,
        "body": json.dumps(response)
    }