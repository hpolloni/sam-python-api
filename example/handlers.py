import logging
import boto3

logging.basicConfig(level=logging.INFO)
log = logging.getLogger(__name__)
log.setLevel(logging.INFO)

def handler(event: dict, context):
    log.info('event: %s', event)
    log.info('context: %s', context)
    return {
        'statusCode' : 200,
        'body': '"OK"'
    }

