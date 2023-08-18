#!/bin/sh
for ARGUMENT in "$@"
do

    KEY=$(echo "$ARGUMENT" | cut -f1 -d=)
    VALUE=$(echo "$ARGUMENT" | cut -f2 -d=)   

    case "$KEY" in
            HELP)               HELP=${VALUE} ;;
            FUNCTION)           FUNCTION=${VALUE} ;;     
            *)   
    esac    


done

if [ "$HELP" != "" ]; then
  echo "./list-aliases.sh FUNCTION=my-lambda"
  exit 0
else
  true
fi

details=$(aws lambda list-aliases --function-name "${FUNCTION}")

echo "$details"