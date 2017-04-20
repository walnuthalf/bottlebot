defmodule Bottlebot do
  use Supervisor
  def init(_arg) do
    # {:ok, pid} = GenServer.start_link(Bottlebot.Handler, [:hello])
    # GenServer.call(pid, :token) 
    children = [
      worker(Login, [Login]),
      worker(Room, [Room])
    ]
    supervise(children, strategy: :one_for_one)
  end
  def start_link do 
    Supervisor.start_link(__MODULE__, [])
  end
end
