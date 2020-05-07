FROM ubuntu:latest

COPY target/release/hello_world /hello_world
EXPOSE 8000
CMD ["/hello_world"]
# ENTRYPOINT ["/hello_world"]