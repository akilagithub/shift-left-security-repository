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
# Copy to Base Image.
# FROM gcr.io/distroless/base-debian10
# COPY --from=build /go/src/app/out/signer /
#CMD ["/signer", "-v=10", "-alsologtostderr", "-mode=check-only", "-policy=policy.yaml","-image=gcr.io/binary-authorization/hello-world@sha256:7c75e4998fd76b1cfc92cb2d7d2a2887d4d9b3f688adb671d316ab163dd3cf40"]

CMD ["/bin/bash"]