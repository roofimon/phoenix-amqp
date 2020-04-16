use Mix.Config

# Configure your database
config :genserv, Genserv.Repo,
  username: "postgres",
  password: "mysecretpassword",
  database: "genserv_dev",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :genserv, GenservWeb.Endpoint,
  http: [port: 4002],
  server: false

