#!/bin/bash
echo "--- Starting integration test ---"
echo "--- Be sure to set ALEXA_APPLICATION_ID... ---"
COMMAND='ask baby genius when was my last diaper change'
if ./node_modules/.bin/ask simulate -t "$COMMAND" -l "en-US" -s $ALEXA_APPLICATION_ID | grep -q 'GetLastDiaperChange'; then
  echo "...OK"
  echo "Passed $COMMAND"
else
  echo "...Failed."
  echo "Failed $COMMAND"
  exit 1
fi

COMMAND='ask baby genius to log a wet diaper at 3 PM'
if ./node_modules/.bin/ask simulate -t "$COMMAND" -l "en-US" -s $ALEXA_APPLICATION_ID | grep -q 'AddDiaperChange'; then
  echo "...OK"
  echo "Passed $COMMAND"
else
  echo "...Failed."
  echo "Failed $COMMAND"
  exit 1
fi
echo "--- Ended integration test ---"
