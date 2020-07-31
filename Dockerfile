# Base image
FROM ubuntu:20.04

# Arguments
ARG COMMIT

# Environtment variables
ENV COMMIT ${COMMIT:-master}
ENV DEBIAN_FRONTEND noninteractive

# Host and Port for libpostal_rest API
ENV LISTEN_HOST 0.0.0.0
ENV LISTEN_PORT 9090

# Install build tools
RUN apt-get update && apt-get install -y \
    autoconf automake build-essential curl git libsnappy-dev libtool pkg-config

# Fetch the libpostal library
RUN git clone https://github.com/openvenues/libpostal -b $COMMIT

# Copy shell scripts for installing libraries
COPY ./*.sh /libpostal/

# Set working directory
WORKDIR /libpostal

# Build libpostal and libpostal-rest libraries
RUN ./build_libpostal.sh
RUN ./build_libpostal_rest.sh

# Open up port for libpostal-rest API
EXPOSE $LISTEN_PORT

# The default command to run when running the container
# In this case, we run the libpostal-rest API
CMD /libpostal/workspace/bin/libpostal-rest
