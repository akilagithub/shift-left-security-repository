#!/bin/bash

# This file will remove all resources built with this blueprint

# Load customer variables
source ./vars.sh
source ./scripts/helper.sh

QUIET="false"

while getopts 'q ': option
do
    case "${option}" in
        q) QUIET="true";;
    esac
done

# Verify required environment variables are set
echo -e "${FANCY_NONE} Verifying Required Environment Variables"
REQ_ENVS=("GOOGLE_PROJECT_ID" "TF_STATE_BUCKET")
verify_env_vars "${REQ_ENVS}"

# Verify required CLI tools are on PATH used gcloud, terraform, gsutil
echo -e "${FANCY_NONE} Verifying Required CLI tools"
REQUIRED=("gcloud" "terraform" "gsutil")
verify_cli_tools "${REQUIRED}"

# Verify state bucket
echo -e "${FANCY_NONE} Verifying access to Terraform Remote State Bucket"
BUCKET=$(gsutil ls -al gs://${TF_STATE_BUCKET} > /dev/null)
if [ $? -gt 0 ]; then
    echo -e "${FANCY_FAIL} Access to Terraform State Bucket failed: $(gsutil ls -al gs://${TF_STATE_BUCKET})"
    exit 1
else
    echo -e "${FANCY_OK} Access to Terraform State Bucket succeeded"
fi

echo -e "${FANCY_NONE} Removing infrastructure"
pushd terraform
    if [[ "${QUIET}" == "true" ]]; then
        terraform destroy -auto-approve
    else
        terraform destroy
    fi
popd
