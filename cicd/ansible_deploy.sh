#!/bin/bash
set -e  # Exit immediately if any command fails
IMAGE=$1

if [ -z "$IMAGE" ]; then
  echo "❌ IMAGE must be provided as arguments."
  exit 1
fi

echo "📦 Starting Ansible Deployment..."
cd terraform
# Load LXC IP from previous step
LXC_IP=$(cat lxc_ip.txt)

# Create dynamic inventory
echo "🛠️ Generating Ansible inventory..."
cat > inventory.ini <<EOF
[spring_lxc]
spring-app ansible_host=$LXC_IP ansible_user=root ansible_ssh_private_key_file=/root/.ssh/id_rsa
EOF

echo "🚀 Running Ansible playbook..."
ansible-playbook -i inventory.ini init-app.yml -e "app_image=$IMAGE"

echo "✅ Ansible deployment completed!"