# Readme

This repository has a docker-compose.yml.

## Installation
1. Run `docker-compose build`
2. Run `docker-compose up`

## Notes
1. Two jobs which use queues:
    - Update Count: This approach allows scalability and do not block concurrent users as well as do not generate race conditions
    - Update Title: This approach allows to update website title without blocking users
2. Log model (ToDo)
    - This model could improve scalability. Report about Top 100 urls could use this log model
3. Development Mode
    - For this only case, docker image is set up to run as a development mode using Sqlite3 and not another database
