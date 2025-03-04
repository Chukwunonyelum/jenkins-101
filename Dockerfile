FROM jenkins/jenkins:2.414.2-jdk11

# Switch to root user
USER root

# Install dependencies
RUN apt-get update && apt-get install -y lsb-release python3-pip

# Add Docker repository and install Docker CLI
RUN curl -fsSLo /usr/share/keyrings/docker-archive-keyring.asc https://download.docker.com/linux/debian/gpg
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.asc] \
  https://download.docker.com/linux/debian $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list
RUN apt-get update && apt-get install -y docker-ce-cli

# Install Jenkins plugins as root
RUN jenkins-plugin-cli --plugins "blueocean:1.25.3 docker-workflow:1.28"

# Ensure the Jenkins user has the right permissions
RUN chown -R jenkins:jenkins /var/jenkins_home
RUN chmod -R 777 /var/jenkins_home

# Switch back to Jenkins user
USER jenkins
