#!/bin/bash
# To connect to the live db use this:
# docker run --rm --name pg-tmp --net=homedashnet -e PGPASSWORD=homedash postgres psql -h homedashdb -U homedash

# Set parameters for database (this should match config/dev.exs)
username=homedash
password=homedash
database=homedash

localdata=/tmp/pg

# Remove old containers if they are present.
docker rm -f homedashdb 
docker rm -f pg-tmp


# Remove and restart the network.
docker network rm homedashnet 
docker network create homedashnet 

# Run the database 
echo "Running database.."
docker run --rm                                     \
           -d                                       \
           --name homedashdb                             \
           --net=homedashnet                             \
           -e POSTGRES_PASSWORD=homedash                 \
           -p 5432:5432                             \
           -v ${localdata}:/var/lib/postgresql/data \
           postgres


sleep 10 # Sleep so the db can boot.

# Create the user.
echo "Creating the user.."
docker run --rm              \
           --name pg-tmp     \
           --net=homedashnet      \
           -e PGPASSWORD=homedash \
           postgres          \
           psql -h homedashdb -U postgres -c "CREATE USER ${username} WITH PASSWORD '${password}' CREATEDB;"

# Create the database.
docker run --rm              \
           --name pg-tmp     \
           --net=homedashnet      \
           -e PGPASSWORD=homedash \
           postgres          \
           psql -h homedashdb -U postgres -c "CREATE DATABASE ${database} OWNER ${username};"