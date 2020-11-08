FROM centos:8
LABEL maintainer="Adam Duskett <aduskett@gmail.com>" \
description="PEV Simulator using risev2g"
ARG RISEV2G_VERSION=1.2.6

# Install dependencies
RUN dnf update -y; \
  dnf install -y epel-release; \
  dnf install -y dnf-plugins-core; \
  dnf config-manager --set-enabled PowerTools;

WORKDIR /tmp

RUN set -e; \
  dnf install -y \
  bash \
  maven \
  nano \
  net-tools \
  openssl \
  wget; \
  wget https://github.com/V2GClarity/RISE-V2G/archive/${RISEV2G_VERSION}.tar.gz -O /tmp/risev2g.tar.gz; \
  mkdir risev2g; \
  mkdir /usr/local/risev2g; \
  tar --strip-components=1 -zxf ./risev2g.tar.gz -C ./risev2g; \
  cd /tmp/risev2g/RISE-V2G-Certificates; \
  sh ./generateCertificates.sh; \
  sh ./copyNewCertsAndKeys.sh; \
  cd /tmp/risev2g/RISE-V2G-PARENT; \
  mvn package;

COPY config/EVCCConfig.properties /usr/local/risev2g/EVCCConfig.properties

RUN set -e; \
  cd /tmp/risev2g/RISE-V2G-EVCC; \
  cp target/rise-v2g-evcc-${RISEV2G_VERSION}.jar /usr/local/risev2g/risev2g.jar; \
  cp evccKeystore.jks /usr/local/risev2g/; \
  rm -rf /tmp/risev2g; \
  rm -rf /root/.mvn;

COPY config/init /init

CMD ["/init"]
