defmodule Xventure.Application do
  use Application

  @impl true
  def start(_type, _args) do
    Figlet.text("Xventure!", font: "figlet.js/Elite.flf")
    children = [{Xventure.World, []}]
    opts = [strategy: :one_for_one, name: Foo.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
