#!/bin/bash
# Copyright 2021 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Overview
# This script provisions the project using Terraform 0.13+

# Load customer variables
source ./vars.sh
source ./scripts/helper.sh

# Verify required environment variables are set
echo -e "${FANCY_NONE} Verifying Required Environment Variables"
REQ_ENVS=("GOOGLE_PROJECT_ID")
verify_env_vars "${REQ_ENVS}"

# Verify required CLI tools are on PATH used gcloud, terraform, gsutil
echo -e "${FANCY_NONE} Verifying Required CLI tools"
REQUIRED=("gcloud" "terraform" "gsutil")
verify_cli_tools "${REQUIRED}"

# Terraform Remote State Bucket
BUCKET=$(gsutil ls -al gs://${TF_STATE_BUCKET} > /dev/null)
if [ $? -gt 0 ]; then
    # bucket doesn't exist or user does not have access
    gsutil mb -p ${GOOGLE_PROJECT_ID} gs://${TF_STATE_BUCKET}
    # Set permissions for the infrastructure account user to access the GCS bucket
    gsutil iam ch serviceAccount:${INFRA_ACCOUNT_EMAIL}:objectCreator,objectViewer gs://${TF_STATE_BUCKET} 1>/dev/null
    echo -e "${FANCY_OK} Crated Terraform State Bucket ${TF_STATE_BUCKET}"
else
    echo -e "${FANCY_OK} Access to Terraform State Bucket succeeded"
fi

# these two take a LONG time and terraform is async, run this ahead of time to ensure brand new projects enable these services
gcloud services enable cloudresourcemanager.googleapis.com secretmanager.googleapis.com > /dev/null 2>&1

echo -e "${FANCY_NONE} Provision (or update) infrastructure"
pushd terraform 1>/dev/null
    terraform init -backend-config="bucket=${TF_STATE_BUCKET}"
    terraform apply -var="project=${GOOGLE_PROJECT_ID}" -auto-approve # no real need for plan
popd 1>/dev/null
