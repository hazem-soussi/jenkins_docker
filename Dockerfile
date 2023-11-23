# Use the official Jenkins LTS image as the base image
FROM jenkins/jenkins:lts

# Switch to the root user to install dependencies
USER root

# Install necessary packages and dependencies
RUN apt-get update && apt-get install -y lsb-release
RUN curl -fsSLo /usr/share/keyrings/docker-archive-keyring.asc \
  https://download.docker.com/linux/debian/gpg
RUN echo "deb [arch=$(dpkg --print-architecture) \
  signed-by=/usr/share/keyrings/docker-archive-keyring.asc] \
  https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list
RUN apt-get update && apt-get install -y docker-ce-cli

# Create the Jenkins home directory if it doesn't exist
RUN mkdir -p /var/jenkins_home

# Set ownership of the Jenkins home directory to the Jenkins user
RUN chown -R jenkins:jenkins /var/jenkins_home

# Switch back to the Jenkins user
USER jenkins

# Install the latest Blue Ocean and Docker Workflow plugins
RUN jenkins-plugin-cli --plugins blueocean docker-workflow

# Optionally, you can install additional plugins here using jenkins-plugin-cli

# Set environment variables (optional)
# ENV JAVA_OPTS="-Dhudson.footerURL=https://your-jenkins-url"

# Optionally, you can copy any custom configurations or scripts into the image

# The Jenkins Blue Ocean port (used to access Blue Ocean UI)
EXPOSE 8080

# The default Jenkins port (used to access the traditional Jenkins UI)

# Start Jenkins
CMD ["sh", "-c", "/usr/local/bin/jenkins.sh"]
