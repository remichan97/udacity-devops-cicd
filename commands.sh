#!/usr/bin/env bash

trap ctrl_c INT

AZ_WEBAPP_NAME='mirai-azure-flash-ml'
cloud=-1

# Helper functions

function ctrl_c {
	printf "\nInterrupt sequence detected. Exiting. \n"
	exit 0
}

function is_running_in_cloud_shell {
	env | grep CLOUDSHELL
	cloud=$?
}

function install_azure_cli {
	IS_INSTALLED=$(dpkg -s azure-cli | grep 'install ok install')
	if [ "" = "$IS_INSTALLED" ]; then
		echo "azure-cli is not found. Installing azure-cli"
		apt update && apt install curl -y && apt install python3.11
		# the one-line installation command acquired from the Microsoft official documentation
		#h ttps://learn.microsoft.com/en-us/cli/azure/install-azure-cli-linux?pivots=apt
		curl -sL https://aka.ms/InstallAzureCLIDeb | bash
	else
		echo "azure-cli is installed, moving on."
	fi
}

function sign_in_to_azure {
	az account show --query user.name &> /dev/null
	IS_SIGNED_IN=$?
	if [ "1" = "$IS_SIGNED_IN" ]; then
		echo "You are not signed in, please follow the upcoming prompt to finish signing in to Azure."
		az login
	else
		echo "We are already signed in, moving on."
	fi
}

# Script body

if [ $EUID -ne 0 ]; then
	echo "Please use sudo to execute the script. Since we need to install some packages before proceeding with the deployment."
	exit 2
fi

is_running_in_cloud_shell
if [ "1" = "$cloud" ]; then
	echo "Running on local machine"
	echo 'Installing azure-cli...'
	install_azure_cli

	echo "Signing in to Azure..."
	sign_in_to_azure
else
	echo "Running on Cloud Shell"
fi

echo "Beginning deployment for webapp $AZ_WEBAPP_NAME..."
az webapp up -n $AZ_WEBAPP_NAME --runtime PYTHON:3.11 --sku B2

echo "Finished!"