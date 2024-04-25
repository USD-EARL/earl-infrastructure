# Adversary Emulation Server Container
FROM ubuntu:23.04
SHELL ["/bin/bash", "-c"]

RUN apt-get -y update \
    && apt-get -y install --no-install-recommends \
        build-essential python3 python3-pip python3-venv golang-go git curl \
    && apt-get clean


RUN mkdir /tools
WORKDIR /tools

# CALDERA
ARG TZ="UTC"
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone


RUN git clone https://github.com/mitre/caldera.git --recursive
WORKDIR /tools/caldera
RUN git checkout f99964d6b96f74e4ca06be962c05085d1d40114d --recurse-submodules
RUN git submodule update --init --recursive

ARG WIN_BUILD=false

# Set up python virtualenv
ENV VIRTUAL_ENV=/opt/venv/caldera
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
# Install pip requirements
RUN pip3 install --no-cache-dir -r requirements.txt

WORKDIR /tools/caldera/app/

# Copy in caldera config file from local EARL repo
COPY ./default.yml /tools/caldera/conf/default.yml

# TODO: build ARM (and others) based agents
# Compile default sandcat agent binaries, which will download basic golang dependencies.

# Install Go dependencies
WORKDIR /tools/caldera/plugins/sandcat/gocat
RUN go mod tidy && go mod download

WORKDIR /tools/caldera/plugins/sandcat
RUN ./update-agents.sh

# Check if we can compile the sandcat extensions, which will download golang dependencies for agent extensions
RUN mkdir /tmp/gocatextensionstest
RUN cp -R ./gocat /tmp/gocatextensionstest/gocat
RUN cp -R ./gocat-extensions/* /tmp/gocatextensionstest/gocat/
RUN cp ./update-agents.sh /tmp/gocatextensionstest/update-agents.sh
WORKDIR /tmp/gocatextensionstest
RUN mkdir /tmp/gocatextensionstest/payloads
RUN ./update-agents.sh

# # Clone atomic red team repo for the atomic plugin
# RUN if [ ! -d "/usr/src/app/plugins/atomic/data/atomic-red-team" ]; then   \
#     git clone --depth 1 https://github.com/redcanaryco/atomic-red-team.git \
#         /usr/src/app/plugins/atomic/data/atomic-red-team;                  \
# fi

# WORKDIR /tools/caldera/plugins/emu

# # If emu is enabled, complete necessary installation steps
# RUN if [ $(grep -c "\- emu" ../../conf/local.yml)  ]; then \
#     apt-get -y install zlib1g unzip;                \
#     pip3 install -r requirements.txt;               \
#     ./download_payloads.sh;                         \
# fi

WORKDIR /tools/caldera

# Install Node.js, npm, and other build VueJS front-end
RUN apt-get update -y \
    && apt-get -y install --no-install-recommends nodejs npm
# # Directly use npm to install dependencies and build the application
WORKDIR /tools/caldera/plugins/magma
# Fix for NPM build issue by installing specific version of vue
RUN npm install && npm install vue@3.2.26 && npm run build
# # Remove Node.js, npm, and other unnecessary packages
RUN apt-get remove -y nodejs npm && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /tools/caldera

# # Install additional tools
RUN apt-get update -y \
    && apt-get -y install --no-install-recommends \
        iproute2 net-tools

# Default HTTP port for web interface and agent beacons over HTTP
EXPOSE 8888
# Default HTTPS port for web interface and agent beacons over HTTPS (requires SSL plugin to be enabled)
EXPOSE 8443
# TCP and UDP contact ports
EXPOSE 7010
EXPOSE 7011/udp
# Websocket contact port
EXPOSE 7012
# Default port to listen for DNS requests for DNS tunneling C2 channel
EXPOSE 8853
# Default port to listen for SSH tunneling requests
EXPOSE 8022
# Default FTP port for FTP C2 channel
EXPOSE 2222

ENTRYPOINT ["python3", "server.py"]
# ENTRYPOINT [ "bash" ]
