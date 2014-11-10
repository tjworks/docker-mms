FROM     centos:centos6
MAINTAINER TJ Tang "jianfa.tang@mognodb.com"

# download mms bits
RUN curl -O https://downloads.mongodb.com/on-prem-mms/rpm/mongodb-mms-1.5.1.137-1.x86_64.rpm

ADD etc/mongodb.repo /etc/yum.repos.d/mongodb.repo
ADD etc/limits.conf  /etc/security/limits.d/90-nproc.conf
RUN yum update -y
RUN yum install -y mongodb-org mongodb-org-shell
RUN rm /etc/security/limits.d/90-nproc.conf

### STABLE ###

RUN yum install -y tar
#RUN mkdir -p /data/mmsdb /data/backupdb /data/heads /data/mongodb-releases 

RUN rpm -U mongodb-mms-1.5.1.137-1.x86_64.rpm
RUN rm mongodb-mms-1.5.1.137-1.x86_64.rpm


RUN curl -O https://downloads.mongodb.com/on-prem-mms/rpm/mongodb-mms-backup-daemon-1.5.1.137-1.x86_64.rpm
RUN rpm -U mongodb-mms-backup-daemon-1.5.1.137-1.x86_64.rpm
RUN rm mongodb-mms-backup-daemon-1.5.1.137-1.x86_64.rpm

RUN yum install -y sudo
ENV mms_email admin@example.com

ADD etc/start-all /opt/start-all
ADD etc/conf-mms.properties /opt/mongodb/mms/conf/conf-mms.properties
ADD etc/conf-daemon.properties /opt/mongodb/mms-backup-daemon/conf/conf-daemon.properties
#CMD /opt/start-all && tail -F /opt/mongodb/mms-backup-daemon/logs/daemon.log
CMD /bin/bash

# bits dir
# http://www.mongodb.com/subscription/downloads/mms

# startup sequence
# mongod --fork --dbpath /data/mmsdb --logpath /data/mmsdb/mmsdb.log  
# mongod --fork --dbpath /data/backupdb --logpath /data/mmsdb.log  --port 27018
# service mongodb-mms start
# service mongodb-mms-backup-daemon start

# manual steps:
# 	register user
# 	install agent

##### Build ####
#  docker build --rm=true -t tjworks/mms .

#####  Local test run ###
# docker run -i -v /home/docker/osx/data/docker-mms:/data  -t tjworks/mms -p 8080:8080 /bin/bash
# docker run -i -v /home/docker/osx/data/docker-mms:/data  -t tjworks/mms /bin/bash

#### Install ###
#	install docker
#	docker run -i -v /data:/data -p 8080:8080 -p 8081:8081 -t tjworks/mms 

# 	docker run -i -t tjworks/mongo-docs -v /home/docker/osx/mongo-docs:/opt/mongo-docs
