#!/bin/bash

# Google project ID number to deploy resources into
# 3 ways to set this variable:
#   1. Set an environment variable called "PROJECT_ID"
#   2. Use the current gcloud configuration's value (default if PROJECT_ID is not set)
#   3. Replace the value with your google project in quotes
export GOOGLE_PROJECT_ID="${PROJECT_ID:-$(gcloud config list --format 'value(core.project)')}"

# Name of the GCS bucket for the terraform state
# 2 ways to change:
#   1. Set an environment variable "TF_STATE_BUCKET" to the name of the bucket
#   2. Replace the value with your bucket name in quotes
export TF_STATE_BUCKET="${TF_STATE_BUCKET:-NOT_FOUND}"
