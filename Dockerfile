ARG SRS_VERSION=2.0.258

FROM arm32v7/debian:jessie-slim AS build

ARG SRS_VERSION
ENV SRS_VERSION=${SRS_VERSION}
ENV SRS_COMMIT=4cb8de3029b4a0f1b2578def6be7771b926ddfa9
ENV SRS_CONFIGURE_ARGS=

RUN set -ex; \
    apt-get update; \
    apt-get install -y --no-install-recommends ca-certificates wget unzip lsb-release;\
    cd /tmp; \
    wget https://github.com/Bit0git/srs-release/raw/master/SRS-Debian8-armv7l-2.0.258.zip; \
    unzip -q SRS-Debian8-armv7l-2.0.258.zip; \
    cd SRS-Debian8-armv7l-2.0.258; \
    bash INSTALL; \
    rm -rf /tmp/*; \
    rm -rf /var/lib/apt/lists/*;  
    

FROM arm32v7/debian:jessie-slim AS dist
ARG SRS_VERSION
ENV SRS_VERSION=${SRS_VERSION}
EXPOSE 1935 1985 8080
COPY --from=build /srs /srs
WORKDIR /srs
CMD ["./objs/srs", "-c", "./conf/docker.conf"]


