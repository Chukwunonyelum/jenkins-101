FROM jenkins/jenkins:2.440.1-jdk11

# Switch to root user
USER root

# Install dependencies
RUN apt-get update && apt-get install -y lsb-release python3-pip

# Add Docker repository and install Docker CLI
RUN curl -fsSLo /usr/share/keyrings/docker-archive-keyring.asc https://download.docker.com/linux/debian/gpg
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.asc] \
  https://download.docker.com/linux/debian $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list
RUN apt-get update && apt-get install -y docker-ce-cli

# Check if jenkins-plugin-cli exists
RUN jenkins-plugin-cli --help || (echo "Installing jenkins-plugin-cli..." && curl -fsSL https://raw.githubusercontent.com/jenkinsci/plugin-installation-manager-tool/master/install-jenkins-plugin-cli.sh | sh)

# Install Jenkins plugins one by one
RUN jenkins-plugin-cli --plugins "blueocean"
RUN jenkins-plugin-cli --plugins "docker-workflow"

# Ensure Jenkins has correct permissions
RUN chown -R jenkins:jenkins /var/jenkins_home
RUN chmod -R 777 /var/jenkins_home

# Switch back to Jenkins user
USER jenkins
