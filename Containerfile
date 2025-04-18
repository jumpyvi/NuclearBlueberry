## 1. BUILD ARGS

# SOURCE_IMAGE arg can be anything from ublue upstream which matches your desired version:
ARG SOURCE_IMAGE="bluefin"

## SOURCE_SUFFIX arg should include a hyphen and the appropriate suffix name
ARG SOURCE_SUFFIX="-dx"

## SOURCE_TAG arg must be a version built for the specific image: eg, 39, 40, gts, latest
ARG SOURCE_TAG="latest"


### 2. SOURCE IMAGE
FROM ghcr.io/ublue-os/${SOURCE_IMAGE}${SOURCE_SUFFIX}:${SOURCE_TAG}


### 3. MODIFICATIONS

COPY build.sh /tmp/build.sh
COPY ublue-logo.png /tmp/ublue-logo.png

RUN mkdir -p /var/lib/alternatives && \
    /tmp/build.sh && \
    cp /tmp/ublue-logo.png /usr/share/pixmaps/fedora-gdm-logo.png && cp /tmp/ublue-logo.png /usr/share/plymouth/themes/spinner/silverblue-watermark.png && \
    ostree container commit
