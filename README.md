# ExAeonsEnd
Helper library for randomizing Aeon's End

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `ex_aeons_end` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ex_aeons_end, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/ex_aeons_end](https://hexdocs.pm/ex_aeons_end).

## Potential Improvements

### Add Property Based Tests
Potentially it would be easy to add property based tests?

### Change Deck to be a GenServer?
Potentially Deck should be a GenServer?

### Missing tests
1. All of player_turn_deck.ex
2. All of ex_aeons_end.ex (but that may not be necessary)
3. deck.ex -> shuffle
