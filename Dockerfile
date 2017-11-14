ARG  JAVA_VER
FROM openjdk:${JAVA_VER}

ENV USER_HOME /home/docker

# Create docker group/user and disable logins
RUN addgroup --gid 1000 docker \
 && adduser --uid 1000 --gid 1000 --disabled-password --gecos "Docker User" --home ${USER_HOME} docker \
 && usermod -L docker

# Configure apt, install updates and common packages, and clean up apt's cache
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
	apt-utils \
    apt-transport-https \
    ca-certificates \
    software-properties-common \
    locales \
 && apt-get install -y --no-install-recommends \
    curl \
    psmisc \
    git \
    build-essential \
    python \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/

# Ensure locale is UTF-8
ENV LANG       en_US.UTF-8
ENV LC_ALL     en_US.UTF-8
ENV LC_TYPE    en_US.UTF-8
ENV LANGUAGE   en_US.UTF-8
RUN echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen \
 && locale-gen \
 && dpkg-reconfigure locales

# Install gradle
USER docker
ENV GRADLE_VERSION 4.1

WORKDIR $USER_HOME
RUN wget  https://services.gradle.org/distributions/gradle-$GRADLE_VERSION-bin.zip \
 && unzip gradle-$GRADLE_VERSION-bin.zip \
 && rm -f gradle-$GRADLE_VERSION-bin.zip \
 && ln -s gradle-$GRADLE_VERSION gradle

ENV IVY_HOME $USER_HOME/ivy_cache
ENV GRADLE_VERSION 4.1
ENV GRADLE_HOME $USER_HOME/gradle
ENV PATH ${PATH}:${GRADLE_HOME}/bin
ENV GRADLE_USER_HOME $USER_HOME/.gradle
