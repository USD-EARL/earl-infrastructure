ARG ELASTIC_VERSION

FROM docker.elastic.co/beats/filebeat:${ELASTIC_VERSION}

# Enable the Zeek module
RUN filebeat modules enable zeek

# Copy the Filebeat configuration file into the container
COPY ./config/filebeat.yml /usr/share/filebeat/filebeat.yml

# Copy the Zeek module configuration if it needs to be customized beyond just enabling it
COPY ./config/zeek.yml /usr/share/filebeat/modules.d/zeek.yml

# Since the Filebeat base image specifies an entrypoint, we use CMD to specify the default command.
CMD ["filebeat", "-e", "--strict.perms=false"]