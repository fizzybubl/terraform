#!/bin/bash

# Endpoint to check
URL="http://internal.example.org"

# Log file
LOG_FILE="test.log"

# Run curl, capture stderr (where curl writes errors)
ERROR_MSG=$(curl -sS "$URL" -o /dev/null 2>&1)
STATUS=$?

# If curl failed, log the error message with timestamp
if [ $STATUS -ne 0 ]; then
    TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
    echo "[$TIMESTAMP] $ERROR_MSG" >> "$LOG_FILE"
fi