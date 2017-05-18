FROM    andystanton/mysql:5.6

ENV EVENTSTORE_PASSWORD PVdiZs8RJWFwJ/muAZbQxP&f

ADD my.cnf /etc/mysql/conf.d/my.cnf
ADD install.sh /tmp/install.sh
ADD create-eventstore-schema.sql /

RUN ["chmod","+x","/tmp/install.sh"]
RUN ["/bin/sh", "-c", "/tmp/install.sh"]


EXPOSE  3306

CMD ["mysqld", "--datadir=/var/lib/mysql", "--user=mysql"]
