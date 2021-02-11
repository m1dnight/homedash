![screenshot](https://raw.githubusercontent.com/m1dnight/homedash/master/screenshot.png)

# Homedash

A dashboard that shows gas, electricity and solar consumption/production.

Homedash exposes an HTTP endpoint where scripts can push data using an access token for security. 

## Deploy 

```
make # builds Docker image.
cd docker/ 
docker-compose up -d 
```

## Development 
```
#Start a development database with the script in 
./scripts/dev_db.sh

#Install the npm dependencies
cd assets && npm install

# Download dependencies 
mix deps.get 

# Compile all the Elixir
mix compile 

# Create the database 
mix ecto.dev 
 ```

