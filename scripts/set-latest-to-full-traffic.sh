for ARGUMENT in "$@"
do

    KEY=$(echo $ARGUMENT | cut -f1 -d=)
    VALUE=$(echo $ARGUMENT | cut -f2 -d=)   

    case "$KEY" in
            HELP)               HELP=${VALUE} ;;
            ALIAS)              ALIAS=${VALUE} ;;
            FUNCTION)           FUNCTION=${VALUE} ;;     
            *)   
    esac    


done

if [ "$HELP" != "" ]; then
  echo "FUNCTION=my-lambda ALIAS=my-alias ./set-latest-to-full-traffic.sh"
  exit 0
else
fi

echo "rolling forward by setting traffic on latest version of function: ${FUNCTION} and alias: ${ALIAS} to 100%"

aws lambda update-alias --name $ALIAS --function-name $FUNCTION --routing-config AdditionalVersionWeights={}