# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :fly_example,
  ecto_repos: [FlyExample.Repo]

# Configures the endpoint
config :fly_example, FlyExample.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "OKj8j4AYp/oiHSUFvOhGOvi0a5ZMfDsBBAvYctzDgWmRQyeITK7vDfk8CMqGb5ME",
  render_errors: [view: FlyExample.ErrorView, accepts: ~w(html json)],
  pubsub: [name: FlyExample.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :fly, :workers,
  %{
    static: {Fly.Worker.StaticText, %{}},
    pngify: {Fly.Worker.Pngify, %{}},
    resize: {Fly.Worker.Resize, %{}},
    video_to_palette: {FlyExample.Worker.VideoToPalette, %{}},
    video_to_gif: {FlyExample.Worker.VideoToGif, %{}},
  }

  #config :porcelain, :driver, Porcelain.Driver.Goon
config :porcelain, :driver, Porcelain.Driver.Basic
config :porcelain, :goon_stop_timeout, 150_000

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
