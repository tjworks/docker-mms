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




RUN yum install -y logrotate
RUN rpm -U /opt/mongodb/mms/agent/monitoring/mongodb-mms-monitoring-agent-2.4.2.113-1.x86_64.rpm
RUN rpm -U /opt/mongodb/mms/agent/backup/mongodb-mms-backup-agent-2.3.1.160-1.x86_64.rpm

#CMD /opt/start-all && tail -F /opt/mongodb/mms-backup-daemon/logs/daemon.log
ADD etc/conf-mms.properties /opt/mongodb/mms/conf/conf-mms.properties
ADD etc/conf-daemon.properties /opt/mongodb/mms-backup-daemon/conf/conf-daemon.properties
ADD etc/start-all /opt/start-all

CMD /bin/bash


# Manual steps:
# 	start /opt/start-all
# 	rm /data/*
#	commit

# bits dir
# http://www.mongodb.com/subscription/downloads/mms


# 	Install docker 
# 	docker run -i -v /data:/data -p 8080:8080 -p 8081:8081 -t tjworks/mms 
# 		/opt/start-all


# startup sequence
# mongod --fork --dbpath /data/mmsdb --logpath /data/mmsdb/mmsdb.log  
# mongod --fork --dbpath /data/backupdb --logpath /data/mmsdb.log  --port 27018
# service mongodb-mms start
# service mongodb-mms-backup-daemon start

##### Build ####
#  docker build --rm=true -t tjworks/mms .


#### Install ###
#	install docker
#	docker run -i -v /data:/data -p 8080:8080 -p 8081:8081 -e mms_email=admin@example.net -t tjworks/mms 

#   cp /data/gen.key /etc/mongodb-mms