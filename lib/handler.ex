defmodule Handler do
  def msg({eventId, roomId, sender, text}) do
    cond do
      String.starts_with?(text, ".choose ") ->
        [_ | tail] = String.split(text, " ")
        sentTxt = Enum.random(tail)
        Room.send_msg(roomId, sentTxt)  
        :sent 
      String.starts_with?(text, ".weather ") ->
        [_, zipcode] = String.split(text, " ", parts: 2)
        sentTxt = sender <> ": " <> Weather.current(zipcode)
        Room.send_msg(roomId, sentTxt)  
        :sent
      true -> :noaction
    end
  end
end
