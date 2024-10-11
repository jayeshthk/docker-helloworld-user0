############################################################
# Dockerfile to build Nginx Installed Containers
# Based on Ubuntu
############################################################

# Set the base image to Ubuntu
FROM ubuntu

# File Author / Maintainer
MAINTAINER Karthik Gaekwad

# Install Nginx

# Update the repository
RUN apt-get update

# Install necessary tools
RUN apt-get install -y vim wget dialog net-tools nginx

# Remove the default Nginx configuration file
RUN rm -v /etc/nginx/nginx.conf

# Copy a configuration file from the current directory
ADD nginx.conf /etc/nginx/

# Create logs directory
RUN mkdir /etc/nginx/logs

# Add a sample index file
ADD index.html /www/data/

# Append "daemon off;" to the beginning of the configuration
RUN echo "daemon off;" >> /etc/nginx/nginx.conf

# Create a runner script for the entrypoint
COPY runner.sh /runner.sh
RUN chmod +x /runner.sh

# Create a non-root user
RUN useradd -r -s /bin/false nginxuser

# Change ownership of necessary directories
RUN chown -R nginxuser:nginxuser /etc/nginx /www/data

# Expose ports
EXPOSE 80

# Switch to the non-root user
USER nginxuser

# Set the entrypoint and default command
ENTRYPOINT ["/runner.sh"]
CMD ["nginx"]
