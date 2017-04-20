defmodule Login do
  use GenServer

  def start_link(name) do
    GenServer.start_link(__MODULE__, [], [name: name])
  end

  def init(_args) do
    conf = %Conf{}
    url = conf.serverURL <> "/_matrix/client/r0/login"
    payload = %{
      "type" => "m.login.password", 
      "user" => conf.matrixUsername, 
      "password" => conf.matrixPass
    }
    json = Common.request(&HTTPotion.post/2, url, payload)
    token = Map.get(json, "access_token")
    {:ok, token}
  end

  def handle_call(:token, _from, state) do
    {:reply, state, state} 
  end
end
