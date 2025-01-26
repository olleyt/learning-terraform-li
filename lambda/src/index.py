import os
import json
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def handler(event, context):
    try:
        # Extract bucket and file details from CloudTrail event
        detail = event['detail']
        bucket_name = detail['requestParameters']['bucketName']
        object_key = detail['requestParameters']['key']
        
        logger.info(f"Hello! A new file '{object_key}' was uploaded to bucket '{bucket_name}'")
        
        return {
            'statusCode': 200,
            'body': json.dumps({
                'message': f"Successfully processed file {object_key}",
                'bucket': bucket_name
            })
        }
    except Exception as e:
        logger.error(f"Error processing event: {str(e)}")
        logger.error(f"Event structure: {json.dumps(event)}")
        return {
            'statusCode': 500,
            'body': json.dumps({
                'error': str(e)
            })
        }