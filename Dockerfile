# Love Alpine
FROM alpine:latest

# Narcissism is not a sin
LABEL maintainer="halo@matriphe.com"

# Ask for SSH info on build
ARG SSH_HOST
ARG SSH_USER
ARG SSH_PASSWORD
ARG SSH_PORT=22

# Ask for DB Info on build
ARG DB_HOST=localhost
ARG DB_PORT=3306

# Set environments
ENV SSH_HOST=${SSH_HOST}
ENV SSH_USER=${SSH_USER}
ENV SSH_PASSWORD=${SSH_PASSWORD}
ENV SSH_PORT=${SSH_PORT}
ENV DB_HOST=${DB_HOST}
ENV DB_PORT=${DB_PORT}

# Set timezone
ENV TIMEZONE="Asia/Jakarta"

# Set workdir
WORKDIR /root

# Install the tools, add it to virtual environment
RUN apk add --no-cache \
    tzdata \
    ca-certificates \
    openssh \
    openssh-client \
    sshpass \
    autossh && \
    echo "${TIMEZONE}" >  /etc/timezone

# Expose port for MySQL, MS SQL, and PostgreSQL
EXPOSE 3306 1433 5432

# Command, use a plain text
ENTRYPOINT sshpass -p ${SSH_PASSWORD:-ssh_password} ssh -p ${SSH_PORT:-ssh_port} -o StrictHostKeyChecking=no -N -L *:${DB_PORT:-db_port}:${DB_HOST:-db_host}:${DB_PORT:-db_port} ${SSH_USER:-ssh_user}@${SSH_HOST:-ssh_host}
