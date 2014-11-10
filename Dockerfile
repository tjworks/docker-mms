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

ENV mms_hostname localhost
RUN sed -i "s/mmsBaseUrl=.*/mmsBaseUrl=$mms_hostname:8080/g" /etc/mongodb-mms/monitor-agent.config
RUN sed -i "s/mothership=.*/mothership=$mms_hostname:8081/g" /etc/mongodb-mms/backup-agent.config

#CMD /opt/start-all && tail -F /opt/mongodb/mms-backup-daemon/logs/daemon.log
ADD etc/conf-mms.properties /opt/mongodb/mms/conf/conf-mms.properties
ADD etc/conf-daemon.properties /opt/mongodb/mms-backup-daemon/conf/conf-daemon.properties

ADD etc/gen.key /etc/mongodb-mms/gen.key
ADD etc/start-mms /opt/start-mms
CMD /bin/bash


# Manual steps for creating image:
# 	start /opt/start-all
#	edit /etc/mongodb-mms/monitoring-agent
#	edit /etc/mongodb-mms/backup-agent
# 	rm /data/*
#	commit

# bits dir
# http://www.mongodb.com/subscription/downloads/mms


# 	Install docker 
#	mount a volume or create a directory with sufficient space at /mmsdata
# 	docker run -i -v /mmsdata:/data -p 8080:8080 -p 8081:8081 -e mms_email=admin@example.com -t tjworks/mms 
# 		/opt/start-mms

 

##### Build ####
#  docker build --rm=true -t tjworks/mms .

 