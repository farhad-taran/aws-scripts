#!/bin/sh
for ARGUMENT in "$@"
do

    KEY=$(echo "$ARGUMENT" | cut -f1 -d=)
    VALUE=$(echo "$ARGUMENT" | cut -f2 -d=)   

    case "$KEY" in
            HELP)               HELP=${VALUE} ;;
            ALIAS)              ALIAS=${VALUE} ;;
            FUNCTION)           FUNCTION=${VALUE} ;;     
            PREVIOUS_VERSION)   PREVIOUS_VERSION=${VALUE} ;;
            PREVIOUS_VERSION_TRAFFIC)   PREVIOUS_VERSION_TRAFFIC=${VALUE} ;;
            *)   
    esac    


done

if [ "$HELP" != "" ]; then
  echo "./split-traffic.sh FUNCTION=my-lambda ALIAS=my-alias PREVIOUS_VERSION_TRAFFIC=0.8 "
  echo "or"
  echo "./split-traffic.sh FUNCTION=my-lambda ALIAS=my-alias PREVIOUS_VERSION=1 PREVIOUS_VERSION_TRAFFIC=0.8 "
  exit 0
else
  true
fi

aws lambda update-alias --name "$ALIAS" --function-name "$FUNCTION" --routing-config AdditionalVersionWeights="{${PREVIOUS_VERSION}=${PREVIOUS_VERSION_TRAFFIC}}"