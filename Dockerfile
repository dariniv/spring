FROM centos:centos7
MAINTAINER Darin IV

####Install Basic tools####
RUN yum -y install net-tools
RUN yum -y install vim
RUN yum -y install nc
RUN yum -y install sudo
RUN yum -y install wget

WORKDIR /opt/jdk
RUN wget -c --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/jdk-8u131-linux-x64.tar.gz
RUN alternatives --install /usr/bin/java java /opt/jdk/jdk1.8.0_131/bin/java 1
RUN alternatives --install /usr/bin/jar jar /opt/jdk/jdk1.8.0_131/bin/jar 1
RUN alternatives --install /usr/bin/javac javac /opt/jdk/jdk1.8.0_131/bin/javac 1
RUN echo "JAVA_HOME=/opt/jdk/jdk1.8.0_131" >> /etc/environment
 
######## TOMCAT SETUP ##########
WORKDIR /opt/tomcat
RUN wget http://apache.cs.utah.edu/tomcat/tomcat-7/v7.0.88/src/apache-tomcat-7.0.88-src.tar.gz
RUN mv  apache-tomcat-7.0.88-src.tar.gz  tomcat7
RUN echo "JAVA_HOME=/opt/jdk/jdk1.8.0_131" >> /etc/default/tomcat7
RUN groupadd tomcat
RUN useradd -s /bin/bash -g tomcat tomcat
RUN chown -Rf tomcat.tomcat /opt/tomcat/tomcat7
EXPOSE 8080
