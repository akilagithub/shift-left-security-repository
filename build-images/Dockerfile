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

# Start by building the application.
FROM golang:1.15-buster as build

# Install gcloud (for authentication to GCR)
ENV CLOUDSDK_INSTALL_DIR /usr/local/gcloud/
RUN curl -sSL https://sdk.cloud.google.com | bash
ENV PATH $PATH:/usr/local/gcloud/google-cloud-sdk/bin

# Install kritis
WORKDIR /go/src
RUN git clone https://github.com/grafeas/kritis
RUN mv kritis app
RUN go get -d -v ./...
WORKDIR /go/src/app
RUN make out/signer
RUN cp out/signer /signer

WORKDIR /

CMD ["/bin/bash"]