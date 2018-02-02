defmodule BabygeniusWeb.PageController do
  use BabygeniusWeb, :controller

  def index(conn, _params) do
    conn
    |> render("index.html")
  end
end