"""
The app module implements lambda handler function.
"""
import json
import logging

logger = logging.getLogger(__name__)
logger.setLevel(logging.INFO)

def handler(event, _):
    """
    Handles the incoming event and context from AWS Lambda.

    :param event: The event dict from AWS Lambda.
    :param context: The context object from AWS Lambda.
    :return: A dict containing the statusCode, event, body, and path.
    """
    try:
        success = False
        message = "Test message"
        body = {"message": str(message)}
        logger.info("result: \n %s ", json.dumps(body))
        response = {
            "statusCode": 200,
            "event": json.dumps(event),
            "body": json.dumps(body),
            "path": "app.py",
        }

        if not success:
            logger.error("result: \n %s ", json.dumps(body))
            response = {
                "statusCode": 500,
                "event": json.dumps(event),
                "body": json.dumps(body),
                "path": "app.py",
            }
        return response

    # pylint: disable=broad-except
    except Exception as ex:
        logger.error("error occured: \n %s ", ex)
        response =  {
            "statusCode": 500,
            "event": json.dumps(event),
            "body": json.dumps({"error": str(ex)}),
            "path": "app.py",
        }
    return response


if __name__ == "__main__":
    handler(None, None)
