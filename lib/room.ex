defmodule Room do
  use GenServer
  def start_link(name) do
    GenServer.start_link(__MODULE__, [], [name: name])
  end

  def init(_args) do
    next_batch()
    # add time to the tuple
    state = messages(:notoken)
    {:ok, state}
  end

  def handle_call(:batch,_from,  state) do
    {:reply, state, state}
  end 

  def handle_info(:nextBatch, state) do
    next_batch()
    {batchToken, roomData} = state 
    {newBT, newRD} = messages(batchToken)
    # only process new messages
    MapSet.difference(newRD, roomData) |> 
    MapSet.to_list |> 
    Enum.map(&Handler.msg/1) 
    {:noreply, {newBT, newRD}}
  end 

  def next_batch do
    Process.send_after(self(), :nextBatch, 2000)
  end

  def send_msg(roomId, text) do
    url = Common.compose_url("/_matrix/client/r0/rooms/#{roomId}/send/m.room.message") 
    payload = %{"msgtype" => "m.text", "body" => text}
    Common.request(&HTTPotion.post/2, url, payload)  
  end
    
  defp process_messages {roomId, val} do
    is_mes = fn(event) -> 
      Map.get(event, "type") == "m.room.message"
    end
    # extract message events
    keypath = ["timeline", "events"]
    {true, events} = Common.dig_map(val, keypath)

    extract = fn(msg) ->
      %{"sender" => sender,
        "event_id" => eventId,
        "content" => 
        %{"body" => text}} = msg
      {eventId, roomId, sender, text}
    end

    events |> 
    Enum.filter(is_mes) |> 
    Enum.map(extract)
  end

  def messages(batchToken) do
    url = Common.compose_url("/_matrix/client/r0/sync") 
    payload = case batchToken do
      :notoken -> %{}
      _ -> %{"since" => batchToken, "filter" => batchToken}
    end
    json = Common.request(&HTTPotion.get/2, url, payload)  
    {true, roomToMsgs} = Common.dig_map(json, ["rooms", "join"])
    {true, nextBatch} = Common.dig_map(json, ["next_batch"])
    newRoomData = Map.to_list(roomToMsgs) |> 
    Enum.flat_map(&process_messages/1) |>
    MapSet.new
    {nextBatch, newRoomData}
  end

end
