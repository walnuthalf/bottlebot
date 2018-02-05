# Bottlebot

Start the supervisor with 

```elixir
{:ok, pid} = Bottlebot.start_link
```

It will automatically log into the matrix server specified in the Conf module (lib/conf.ex).
At the moment, bottlebot has to be "attached" or "detached" to rooms manually. If it is attached/joined, it will poll all messages. 


Extend Bottlebot by adding more to the Handler module in lib/handler.ex


Happy hacking!

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `bottlebot` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:bottlebot, "~> 0.1.0"}]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/bottlebot](https://hexdocs.pm/bottlebot).

