# find out if vpc is being used by any resources
aws ec2 describe-network-interfaces \                
  --region $1 --output json \
  --query "NetworkInterfaces[*].[NetworkInterfaceId,Description,PrivateIpAddress,VpcId,Groups]"
