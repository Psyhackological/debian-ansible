# Use a specific Debian image
FROM debian:12.1

# Set shell with pipefail option
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install specific versions of python3, pip, and openssh-server
# Use --no-install-recommends to avoid additional packages
# Configure SSH for root login
# Clean-up cache
RUN apt-get update && \
    apt-get install --no-install-recommends -y python3=3.11.2-1+b1 python3-pip=23.0.1+dfsg-1 openssh-server=1:9.2p1-2 && \
    echo "root:root" | chpasswd && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    mkdir -p /var/run/sshd && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Use a non-root user (this is just an example; adapt as needed)
# RUN useradd -m myuser && \
#     echo "myuser:password" | chpasswd

# Expose port 22 for SSH
EXPOSE 22

# Run SSH server in the foreground
CMD ["/usr/sbin/sshd", "-D"]
