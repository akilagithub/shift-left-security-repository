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
