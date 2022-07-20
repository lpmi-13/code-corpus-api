PUBLIC_IP=$(curl -s ifconfig.co/json | jq '.ip')

sed -i "s/^public_ip.*/public_ip = $PUBLIC_IP/" terraform.tfvars
