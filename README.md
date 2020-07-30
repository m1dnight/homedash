# HomeDash

# Build / Deploy using Docker 

Home Dash uses a `config/releases.exs` file, so most of the variables need to be set in the environment for it to work. The environment is located in `./docker/.env`. Adapt accordingly.

| Env Variable        | Description                                                                  |
|---------------------|------------------------------------------------------------------------------|
| `DATABASE_DB`       | The name of the database in the Postgres container.                          |
| `DATABASE_USER`     | The username for the database container.                                     |
| `DATABASE_PASSWORD` | Password for the database container.                                         |
| `APP_HOST`          | The hostname bound to the app. e.g., homedash.example.com.                   |
| `LIVE_VIEW_SALT`    | The salt to encrypt the LiveView sockets. Generate with `mix phx.gen.secret` |
| `SECRET_KEY_BASE`   | Secret signging and encryption salt. Generate with `mix phx.gen.secret`.     |
| `PORT`              | The port on which the application will listen.                               |


Then build the Docker image by issueing `docker-compose build`. After that, run the application with `docker-compose up -d` and you should be able to access the application.