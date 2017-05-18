#!/bin/bash

# start mysql server as a background process so we can modify it
mysqld --datadir=/var/lib/mysql --user=mysql &

# wait for mysqld to start
counter=0
while (( ${counter} < "30" )); do
    let counter=counter+1
    mysql_status="$(mysql -N -B -uroot -hlocalhost -e "SELECT 'ready';" 2> /dev/null)"
    if [[ ${mysql_status} == "ready" ]]; then break; fi
    sleep 1s
done

# error if db doesn't come up
if [[ ${mysql_status} != "ready" ]]; then
  echo "Database did not start within 30 seconds"
  exit 1
fi

# Create user
mysql -hlocalhost -uroot -e "CREATE USER 'eventstore'@'%' IDENTIFIED BY '${EVENTSTORE_PASSWORD}';"

# Perform custom operations to create and populate database. liquibase or flyway > command line mysql
mysql -hlocalhost -uroot < /create-eventstore-schema.sql

# shut down mysqld
mysqladmin -uroot shutdown

exit 0
