#!/bin/bash
set -e  # Exit immediately if any command fails

echo "📦 Starting Terraform Deployment..."

cd terraform
# Initialize Terraform (upgrade plugins if necessary)
terraform init -upgrade

# Apply Terraform plan automatically
terraform apply -auto-approve \
  -var "pm_api_url=https://172.30.1.81:8006/api2/json" \
  -var "pm_api_token_id=$PM_TOKEN_ID" \
  -var "pm_api_token_secret=$PM_TOKEN_SECRET" \
  -var "container_password=$APP_CONTAINER_PASSWORD"

echo "🌐 Extracting LXC IP from Terraform output..."
LXC_IP=$(terraform output -raw lxc_ip)
echo "LXC IP: $LXC_IP"

# 🚫 Remove old fingerprint to prevent SSH 'host changed' error
echo "🔑 Cleaning up known_hosts fingerprint for $LXC_IP..."
ssh-keygen -R "$LXC_IP" || true

# Wait until SSH is ready
echo "🕐 Waiting for SSH on $LXC_IP..."
for i in {1..20}; do
  ssh -o StrictHostKeyChecking=no -o ConnectTimeout=5 -i /root/.ssh/id_rsa root@$LXC_IP "echo 'SSH is ready'" && break
  echo "⏳ Still waiting for SSH..."
  sleep 5
done

# Save IP for Ansible deploy
echo "$LXC_IP" > lxc_ip.txt

echo "✅ Terraform deployment completed!"