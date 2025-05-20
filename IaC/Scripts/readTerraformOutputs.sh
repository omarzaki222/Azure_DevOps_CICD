#!/bin/bash

# install jq
sudo apt-get update
sudo apt-get install jq -y
jq --version


TERRAFORM_DIR=$workingDirectory
cd "$TERRAFORM_DIR"

# Path to the JSON file with Terraform outputs
JSON_OUTPUT_PATH=$jsonOutputVariablesPath


# Check if jq is installed
if ! command -v jq &> /dev/null
then
    echo "jq could not be found, please install jq to run this script."
    exit 1
fi

# Read each key (output name) and value from the JSON file and set them as environment variables
for key in $(jq -r 'keys[]' "$JSON_OUTPUT_PATH"); do
    key_value=$(jq -r ".[\"$key\"]" "$JSON_OUTPUT_PATH")
    value=$(echo "$key_value" | jq -r '.value')
    # echo "##vso[task.setvariable variable=$key;isOutput=true]$value"
    echo "##vso[task.setvariable variable=$key]$value"
    export $key=$value
    echo "Exported $key=$value"
done

