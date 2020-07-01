# Start by building the application.
FROM golang:1.14-buster as build

# Install gcloud (for authentication to GCR)
ENV CLOUDSDK_INSTALL_DIR /usr/local/gcloud/
RUN curl -sSL https://sdk.cloud.google.com | bash
ENV PATH $PATH:/usr/local/gcloud/google-cloud-sdk/bin

# Install kritis
WORKDIR /go/src
RUN git clone --branch policy-check-v1.0.0 https://github.com/grafeas/kritis
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