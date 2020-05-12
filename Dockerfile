FROM ubuntu:18.04

# Build-time metadata as defined at http://label-schema.org
ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
ARG ADDITIONAL_PACKAGES

LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name="Connect IQ SDK" \
      org.label-schema.description="CTI Connect IQ SDK" \
      org.label-schema.url="private" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/chesapeaketechnology/docker-connectiq" \
      org.label-schema.vendor="CTI" \
      org.label-schema.version=$VERSION \
      org.label-schema.schema-version="1.0"

ENV LANG C.UTF-8

# Compiler tools
RUN apt-get update -y && \
    apt-get install -qqy openjdk-8-jdk && \
    apt-get install -qqy unzip wget git ssh tar gzip ca-certificates libusb-1.0 libpng16-16 libgtk2.0-0 libwebkitgtk-1.0-0 libwebkitgtk-3.0-0 && \
    apt-get clean && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN echo "Downloading Connect IQ SDK: ${VERSION}" && \
    cd /opt && \
    wget -q https://developer.garmin.com/downloads/connect-iq/sdks/connectiq-sdk-lin-${VERSION}.zip -O ciq.zip && \
    unzip ciq.zip -d ciq && \
    rm -f ciq.zip

# Fix missing libpng12 (monkeydo)
RUN ln -s /usr/lib/x86_64-linux-gnu/libpng16.so.16 /usr/lib/x86_64-linux-gnu/libpng12.so.0

ENV GARMIN_SDK_HOME /opt/ciq/

RUN openssl genrsa -out ${GARMIN_SDK_HOME}/developer_key.pem 4096
RUN openssl pkcs8 -topk8 -inform PEM -outform DER -in ${GARMIN_SDK_HOME}/developer_key.pem -out ${GARMIN_SDK_HOME}/developer_key.der -nocrypt

ENV GARMIN_DEV_KEY ${GARMIN_SDK_HOME}/developer_key.der
ENV PATH ${PATH}:${GARMIN_SDK_HOME}/bin:${GARMIN_DEV_KEY}

CMD [ "/bin/bash" ]