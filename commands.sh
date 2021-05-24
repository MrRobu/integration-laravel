#!/bin/bash

docker-compose exec postgres sh -c 'psql postgres < cabvet-postgres-dump.sql'

docker-compose exec postgres psql postgres

docker-compose exec oracle sh -c 'source /home/oracle/.bashrc && sqlplus / as sysdba < cabvet-oracle-dump.sql'

docker-compose exec oracle sh -c 'source /home/oracle/.bashrc && sqlplus / as sysdba'

# SQL> set linesize 1000
# # isql pg
