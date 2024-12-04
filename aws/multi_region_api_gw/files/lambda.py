def handler_name(event, context): 
    return {
        "message": f"Hello from {os.environ['AWS_REGION']}"
        "event": event
    }