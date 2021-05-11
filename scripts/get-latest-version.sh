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
  echo "FUNCTION=my-lambda ./get-latest-version.sh"
  exit 0
else
  true
fi

latest_version=$(aws lambda list-versions-by-function --function-name "${FUNCTION}" \
  --no-paginate \
  --query "max_by(Versions, &to_number(to_number(Version) || '0'))" | jq -r ".Version")

echo "$latest_version"