FROM ubuntu:22.04

RUN apt update -y
RUN apt-get install -y apache2 
RUN apt-get install -y apache2-utils
RUN sed -i 's/Listen 80/Listen 3001/g' /etc/apache2/ports.conf
EXPOSE 3001

CMD ["apache2ctl", "-D", "FOREGROUND"]

#docker build . -t apache_ubuntu -f /opt/docker/Dockerfile