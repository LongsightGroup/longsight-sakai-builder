# Longsight Sakai Builder
FROM ubuntu:precise
MAINTAINER Sam Ottenhoff <ottenhoff@longsight.com>

## DEPENDENCIES ##
RUN apt-get update && apt-get install --assume-yes python-software-properties curl default-jdk subversion git sed

WORKDIR /tmp/sakai-builder

RUN curl -o /tmp/maven.tar.gz http://10.4.100.100/sakai-builder/maven221.tar.gz
RUN mkdir /usr/local/maven
RUN tar -C /usr/local/maven/ -xzvf /tmp/maven.tar.gz

#run echo "postfix postfix/main_mailer_type string Internet site" > preseed.txt
#run echo "postfix postfix/mailname string docker.longsight.com" >> preseed.txt
#run debconf-set-selections preseed.txt
#run DEBIAN_FRONTEND=noninteractive apt-get install -q -y postfix
#run postconf -e relayhost="10.4.100.100"

ENV MAVEN_OPTS -XX:MaxPermSize=512m -Xms1g -Xmx1g
ENV JAVA_HOME /usr/lib/jvm/default-java
ENV MAVEN_HOME /usr/local/maven
ENV PATH $PATH:/usr/lib/jvm/default-java/bin:/usr/local/maven/bin

RUN curl -o /usr/local/bin/sakai_build_script-v15.sh http://10.4.100.100/sakai-builder/sakai_build_script.sh

RUN mkdir -p /home/sakai/applet-keystore
RUN curl -o /home/sakai/applet-keystore/audio_applet_keystore http://10.4.100.100/sakai-builder/audio_applet_keystore

# Cache the MVN tarballs
RUN echo "<settings> <mirrors> <mirror> <id>longsight-nginx</id> <name>LSNginx</name> <url>http://mvnproxy.longsight.com/maven2</url> <mirrorOf>central</mirrorOf> </mirror> </mirrors> </settings>" > /usr/local/maven/conf/settings.xml

ENTRYPOINT ["bash","/usr/local/bin/sakai_build_script-v15.sh"]
