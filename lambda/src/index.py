def handler(event, context):
    try:
        # Extract bucket and file details from event
        detail = event['detail']
        bucket_name = detail['bucket']['name']
        object_key = detail['object']['key']
        
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
        return {
            'statusCode': 500,
            'body': json.dumps({
                'error': str(e)
            })
        }