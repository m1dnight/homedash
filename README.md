# HomeDash

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

# Build / Deploy using Docker 

Home Dash uses a `config/releases.exs` file, so most of the variables need to be set in the environment for it to work. 

 * `SECRET_KEY_BASE` is the secret key base. Generate this using `mix phx.gen.secret`.
 * `DATABASE_HOST=localhost` is the path to the database. This will probably be another Docker container (docker-compose).
 * `HOSTNAME` is the hostname the application will run on, defaults to `example.com`.


docker rm -f homedash ; docker run --rm -e HOSNTAME=example.com -e DATABASE_HOST=homedashdb -e SECRET_KEY_BASE=1 -p 4000:4000 --net=homedashnet --name homedash m1dnight/homedash:latest /bin/bashe