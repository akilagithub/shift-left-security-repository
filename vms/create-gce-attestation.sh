#!/bin/bash -e
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


TARGET="sample-vm" # "$1"

if [[ -z "$TARGET" ]]; then
    echo "Please specifiy a VM instance name"
fi


export ATTESTING_USER="build-attestor"
export ATTESTOR_NAME="projects/${PROJECT_ID}/attestors/${ATTESTING_USER}"
export DIGEST_TEMPLATE="0000000000000000000000000000000000000000000000000000000000000000" # 64 character

KEY_VERSION="1"
KEY_NAME="${KEY_NAME:-keyname}"
KEY_RING="${KEY_RING:-attestor-key-ring-tough-lizard}"
KEY_LOCATION="${KEY_LOCATION:-us-central1}"
KEY_ALGORITHM="sha512"

# Get the ID of the VM desired
ID=$(gcloud compute instances describe ${TARGET} --format="value(id)")
if [[ $? > 0 ]]; then
    echo "VM Not Found"
    exit 1
fi

## TODO: Get a fingerprint?  What else should be a part of the digest?

DIGEST="${DIGEST_TEMPLATE:0:-${#ID}}$ID" # left-pad 0s to 64 characters
ARTIFACT_URL="example.com/${PROJECT_ID}/sample-vm@sha256:${DIGEST}" # needs to follow some convention of "looking like docker repo"


# All attestors
# gcloud container binauthz attestors list

echo "BEFORE:::::::::All attestations for ${TARGET}"
# List current attestations
gcloud beta container binauthz attestations list \
    --artifact-url="${ARTIFACT_URL}" \
    --attestor=build-attestor \
    --attestor-project=${PROJECT_ID} \
    --format=yaml


gcloud container binauthz create-signature-payload \
    --artifact-url="${ARTIFACT_URL}" > signed-payload.txt

gcloud kms keys versions get-public-key 1 \
    --key ${KEY_NAME} \
    --keyring ${KEY_RING} \
    --location ${KEY_LOCATION} \
    --output-file public-key.pub

gcloud kms asymmetric-sign \
    --version ${KEY_VERSION} \
    --key ${KEY_NAME} \
    --keyring ${KEY_RING} \
    --location ${KEY_LOCATION} \
    --digest-algorithm ${KEY_ALGORITHM} \
    --input-file signed-payload.txt \
    --signature-file signed-payload.pgp

gcloud container binauthz attestations create \
    --public-key-id projects/${PROJECT_ID}/locations/${KEY_LOCATION}/keyRings/${KEY_RING}/cryptoKeys/${KEY_NAME}/cryptoKeyVersions/${KEY_VERSION} \
    --signature-file=signed-payload.pgp \
    --artifact-url="${ARTIFACT_URL}" \
    --attestor=${ATTESTOR_NAME}

echo "AFTER :::::::::::: All attestations for ${TARGET}"
# List current attestations
gcloud beta container binauthz attestations list \
    --artifact-url="${ARTIFACT_URL}" \
    --attestor=build-attestor --attestor-project=${PROJECT_ID} \
    --format=yaml

# Current policy ( can be used for scripting, this is a YAML file )
# gcloud beta container binauthz policy export

# rm -rf *.pgp
# rm -rf *.txt
# rm -rf *.pub