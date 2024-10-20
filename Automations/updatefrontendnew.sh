#!/bin/bash

# Set the VM Name and Resource Group for Azure VM
VM_NAME="jenkins-server"           # Replace with your Azure VM name
RESOURCE_GROUP="myrg"              # Replace with your Resource Group

# Retrieve the public IP address of the specified Azure VM
ipv4_address=$(az vm list-ip-addresses --name $VM_NAME --resource-group $RESOURCE_GROUP --query '[0].virtualMachine.network.publicIpAddresses[0].ipAddress' --output tsv)

# Path to the .env file
file_to_find="../frontend/.env.docker"   # Replace with the correct path to your .env file

# Check the current VITE_API_PATH in the .env file
current_url=$(cat $file_to_find)

# Update the .env file if the IP address has changed
if [[ "$current_url" != "VITE_API_PATH=\"http://${ipv4_address}:31100\"" ]]; then
    if [ -f $file_to_find ]; then
        sed -i -e "s|VITE_API_PATH.*|VITE_API_PATH=\"http://${ipv4_address}:31100\"|g" $file_to_find
        echo "Updated VITE_API_PATH to http://${ipv4_address}:31100"
    else
        echo "ERROR: .env.docker file not found."
    fi
else
    echo "No changes needed. VITE_API_PATH is already up-to-date."
fi
