
#!/bin/bash
# To connect to the live db use this:
# docker run --rm --name pg-tmp --net=homedashnet -e PGPASSWORD=homedash postgres psql -h homedashdb -U homedash

# Set parameters for database (this should match config/dev.exs)
username=postgres
password=postgres
database=homedashdb


localdata=$(mktemp -d)
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
           --name homedashdb                        \
           --net=homedashnet                        \
           -e POSTGRES_PASSWORD=postgres            \
           -e TZ='Europe/Brussels'                  \
           -p 5432:5432                             \
           -v ${localdata}:/var/lib/postgresql/data \
           postgres:12

           
sleep 10s           

# Create the database.
docker run --rm                   \
           --name pg-tmp          \
           --net=homedashnet      \
           -e PGPASSWORD=postgres \
           postgres:12            \
           psql -h homedashdb -U postgres -c "CREATE DATABASE ${database} OWNER ${username};"


# REPL
# docker run --rm                   \
#            -it                    \
#            --name pg-tmp          \
#            --net=homedashnet      \
#            -e PGPASSWORD=postgres \
#            postgres               \
#            psql -h homedashdb -U postgres homedashdb
