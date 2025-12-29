FROM jenkins/jenkins:2.543-jdk21
USER root
RUN apt-get update && apt-get install -y \
    lsb-release \
    python3 \
    python3-pip \
    python3.13-venv \
    libgbm1 \
    wget \
    unzip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
RUN apt-get update && apt-get install -y ./google-chrome-stable_current_amd64.deb
RUN rm google-chrome-stable_current_amd64.deb
RUN google-chrome --version
RUN wget https://storage.googleapis.com/chrome-for-testing-public/143.0.7499.169/linux64/chromedriver-linux64.zip
RUN unzip chromedriver-linux64.zip
RUN mv chromedriver-linux64/chromedriver /usr/bin/chromedriver
RUN rm -rf chromedriver-linux64 chromedriver-linux64.zip
RUN chown root:root /usr/bin/chromedriver
RUN chmod +x /usr/bin/chromedriver
RUN chromedriver --version
RUN curl -fsSLo /usr/share/keyrings/docker-archive-keyring.asc \
  https://download.docker.com/linux/debian/gpg
RUN echo "deb [arch=$(dpkg --print-architecture) \
  signed-by=/usr/share/keyrings/docker-archive-keyring.asc] \
  https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list
RUN apt-get update && apt-get install -y docker-ce-cli
USER jenkins
RUN jenkins-plugin-cli --plugins "blueocean docker-workflow json-path-api token-macro"