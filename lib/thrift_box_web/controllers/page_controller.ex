defmodule ThriftBoxWeb.PageController do
  use ThriftBoxWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
