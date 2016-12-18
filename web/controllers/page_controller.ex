defmodule FlyExample.PageController do
  use FlyExample.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
