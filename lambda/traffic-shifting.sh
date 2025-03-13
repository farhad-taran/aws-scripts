            
#!/bin/sh
for ARGUMENT in "$@"
do

    KEY=$(echo "$ARGUMENT" | cut -f1 -d=)
    VALUE=$(echo "$ARGUMENT" | cut -f2 -d=)   

    case "$KEY" in
            ALIAS)              ALIAS=${VALUE} ;;
            FUNCTION)           FUNCTION=${VALUE} ;;     
            GRACE_MINUTES)      GRACE_MINUTES=${VALUE} ;;
            PERCENTAGE)         PERCENTAGE=${VALUE} ;;
            REGION)             REGION=${VALUE} ;;
            *)   
    esac    


done

if [ $PERCENTAGE -lt "0" ]; then
    PERCENTAGE=0
fi

MAX_PERCENTAGE=100
GRACE_MINUTES_CM=${GRACE_MINUTES}m

LATEST_VERSION=$(aws lambda --region "$REGION" list-versions-by-function --function-name "${FUNCTION}" \
  --no-paginate \
  --query "max_by(Versions, &to_number(to_number(Version) || '0'))" | jq -r ".Version")
PREVIOUS_VERSION=$((LATEST_VERSION-1))

echo "lambda latest version: $LATEST_VERSION"
echo "lambda previous version: $PREVIOUS_VERSION"

while [[ $PERCENTAGE -lt $MAX_PERCENTAGE ]]
do
    echo "waiting for grace period: ${GRACE_MINUTES_CM}"
    
    sleep $GRACE_MINUTES_CM
    
    PERCENTAGE=$(($PERCENTAGE * 2))
    
    if [ $PERCENTAGE -gt "100" ]; then
        PERCENTAGE=100
    fi
    
    LATEST_VERSION_PERCENTAGE=$PERCENTAGE

    # in order for traffic shifting to work, the percentage is set on the previous version and not the latest version
    PREVIOUS_VERSION_PERCENTAGE=$((100-$LATEST_VERSION_PERCENTAGE))
    
    echo "setting latest version: $LATEST_VERSION traffic to $LATEST_VERSION_PERCENTAGE %"
    echo "setting previous version: $PREVIOUS_VERSION traffic to $PREVIOUS_VERSION_PERCENTAGE %"
    
    PERCENTAGE_DECIMAL=$(awk "BEGIN {printf \"%.1f\",$PERCENTAGE/100}")
    aws lambda update-alias --region "$REGION" --name "$ALIAS" --function-name "$FUNCTION" --routing-config AdditionalVersionWeights="{${VERSION}=${PERCENTAGE_DECIMAL}}"
done
