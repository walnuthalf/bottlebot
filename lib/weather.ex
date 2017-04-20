defmodule Weather do
  def current(zipcode) do
    conf = %Conf{}
    paramStr = "?zip=#{zipcode}&units=imperial"
    keyStr = "&APPID=#{conf.weatherKey}"
    url = "http://api.openweathermap.org/data/2.5/weather" <> paramStr <> keyStr
    json = Common.simple_get(url)
    %{"main" => %{
      "humidity" => humidity,
      "temp" => temp,
      "temp_min" => tempMin,
      "temp_max" => tempMax
      },
      "weather" => wlist
    } = json 
    description = Enum.map(wlist, fn el -> Map.get(el, "description") end) 
                  |> Enum.join(", ") 
    [
      "temp: #{temp}", 
      "max temp: #{tempMax}",
      "min temp: #{tempMin}", 
      "humidity: #{humidity}",
      "description: #{description}"
    ] |> Enum.join(", ")
  end
end
