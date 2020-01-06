defmodule ExAeonsEnd.Deck do
  @moduledoc "
  This is a generic abstraction for a deck of cards, consisting of a draw pile and a discard pile.
  "

  alias ExAeonsEnd.Card

  defstruct [:draw, :discard]

  @type t :: %__MODULE__{
          draw: list(Card.t()),
          discard: list(Card.t())
        }

  @type pile :: :draw | :discard

  @spec new :: __MODULE__.t()
  def new do
    %__MODULE__{
      draw: [],
      discard: []
    }
  end

  @doc """
  This function prepends a card to a pile for the deck (either the draw pile or discard pile).

  ## Examples

  iex> ExAeonsEnd.Deck.new
  ...> |> ExAeonsEnd.Deck.add_card(:draw, %ExAeonsEnd.Card{id: 1, name: "a"})
  ...> |> ExAeonsEnd.Deck.add_card(:draw, %ExAeonsEnd.Card{id: 2, name: "b"})
  %ExAeonsEnd.Deck{draw: [%ExAeonsEnd.Card{id: 2, name: "b"}, %ExAeonsEnd.Card{id: 1, name: "a"}], discard: []}

  iex> ExAeonsEnd.Deck.new
  ...> |> ExAeonsEnd.Deck.add_card(:discard, %ExAeonsEnd.Card{id: 1, name: "a"})
  ...> |> ExAeonsEnd.Deck.add_card(:discard, %ExAeonsEnd.Card{id: 2, name: "b"})
  %ExAeonsEnd.Deck{discard: [%ExAeonsEnd.Card{id: 2, name: "b"}, %ExAeonsEnd.Card{id: 1, name: "a"}], draw: []}

  iex> ExAeonsEnd.Deck.new
  ...> |> ExAeonsEnd.Deck.add_card(:draw, %ExAeonsEnd.Card{id: 1, name: "a"})
  ...> |> ExAeonsEnd.Deck.add_card(:discard, %ExAeonsEnd.Card{id: 2, name: "b"})
  %ExAeonsEnd.Deck{draw: [%ExAeonsEnd.Card{id: 1, name: "a"}], discard: [%ExAeonsEnd.Card{id: 2, name: "b"}]}
  """
  @spec add_card(__MODULE__.t(), __MODULE__.pile(), Card.t()) :: __MODULE__.t()
  def add_card(deck, pile_type, card)

  def add_card(deck = %__MODULE__{draw: draw}, :draw, card),
    do: %__MODULE__{deck | draw: [card | draw]}

  def add_card(deck = %__MODULE__{discard: discard}, :discard, card),
    do: %__MODULE__{deck | discard: [card | discard]}

  # This is probably best tested with a property test?
  @spec shuffle(__MODULE__.t()) :: __MODULE__.t()
  def shuffle(deck), do: %__MODULE__{deck | draw: deck.draw |> Enum.shuffle()}

  @doc """
  This function pops the first card off of the draw pile, or returns :empty if the draw is empty.

  ## Examples

  iex> alias ExAeonsEnd.{Deck, Card}
  ...> Deck.new
  ...> |> Deck.add_card(:draw, %Card{id: 1, name: "a"})
  ...> |> Deck.add_card(:draw, %Card{id: 2, name: "b"})
  ...> |> Deck.draw()
  {%ExAeonsEnd.Card{id: 2, name: "b"}, %ExAeonsEnd.Deck{draw: [%ExAeonsEnd.Card{id: 1, name: "a"}], discard: []}}

  iex> alias ExAeonsEnd.{Deck, Card}
  ...> Deck.new
  ...> |> Deck.add_card(:discard, %Card{id: 1, name: "a"})
  ...> |> Deck.add_card(:discard, %Card{id: 2, name: "b"})
  ...> |> Deck.draw()
  {:empty, %ExAeonsEnd.Deck{discard: [%ExAeonsEnd.Card{id: 2, name: "b"}, %ExAeonsEnd.Card{id: 1, name: "a"}], draw: []}}
  """
  @spec draw(__MODULE__.t()) :: {Card.t(), __MODULE__.t()} | {:empty, __MODULE__.t()}
  def draw(deck)

  def draw(deck = %__MODULE__{draw: []}), do: {:empty, deck}

  def draw(deck = %__MODULE__{draw: [card | draw]}) do
    {card, %__MODULE__{deck | draw: draw}}
  end
end
