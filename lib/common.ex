defmodule Common do
  def dig_map(map, keypath) do
    case keypath do
      [] -> {true, map} 
      [head | tail] -> 
        val = Map.get(map, head)
        if val == nil do
          {false, val}
        else
          dig_map(val, tail)
        end
    end
  end

  def compose_url(endpoint) do
    conf = %Conf{} 
    tokenStr = "?access_token=#{GenServer.call(Login, :token)}"
    conf.serverURL <> endpoint <> tokenStr
  end

  def do_each_key(map, func) do
    Map.to_list(map) |> Enum.map(func) 
  end

  def compare_lists(l1, l2, compare_fn) do
    Enum.zip(l1, l2) |>
    Enum.map(compare_fn) |>
    Enum.reduce(fn(el1, el2) -> el1 and el2 end)
  end

  def simple_get(url) do 
    %{body: body} = HTTPotion.get(url, [])
    {:ok, json} = Poison.decode(body) 
    json
  end

  def request(reqfunc, url, payload)  do
    {:ok, payloadStr} = Poison.encode(payload)
    params = [
      body: payloadStr,
      headers: [
        "User-Agent": "bot",
        "Content-Type": "application/x-www-form-urlencoded"
      ]
    ]

    %{body: body} = reqfunc.(url, params)
    {:ok, json} = Poison.decode(body) 
    json
  end
end
