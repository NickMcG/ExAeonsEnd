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

  @doc """
  This function returns the contents of one of the piles without updating the deck.

  ## Examples

  iex> ExAeonsEnd.Deck.new |> ExAeonsEnd.Deck.view_pile(:draw)
  []

  iex> ExAeonsEnd.Deck.new |> ExAeonsEnd.Deck.view_pile(:discard)
  []

  iex> alias ExAeonsEnd.{Deck, Card}
  ...> Deck.new
  ...> |> Deck.add_card(:draw, %Card{id: 1, name: "a"})
  ...> |> Deck.add_card(:draw, %Card{id: 2, name: "b"})
  ...> |> Deck.view_pile(:draw)
  [%ExAeonsEnd.Card{id: 2, name: "b"}, %ExAeonsEnd.Card{id: 1, name: "a"}]

  iex> alias ExAeonsEnd.{Deck, Card}
  ...> Deck.new
  ...> |> Deck.add_card(:discard, %Card{id: 1, name: "a"})
  ...> |> Deck.add_card(:discard, %Card{id: 2, name: "b"})
  ...> |> Deck.view_pile(:discard)
  [%ExAeonsEnd.Card{id: 2, name: "b"}, %ExAeonsEnd.Card{id: 1, name: "a"}]
  """
  @spec view_pile(__MODULE__.t(), __MODULE__.pile()) :: list(Card.t())
  def view_pile(deck, pile_type)

  def view_pile(deck, :draw), do: deck.draw
  def view_pile(deck, :discard), do: deck.discard

  @doc """
  This function sets the contents of one of the piles in the deck.

  ## Examples

  iex> alias ExAeonsEnd.{Deck, Card}
  ...> pile = [%Card{id: 42, name: "x"}, %Card{id: 43, name: "y"}]
  ...> ExAeonsEnd.Deck.new |> ExAeonsEnd.Deck.set_pile(:draw, pile)
  %ExAeonsEnd.Deck{draw: [%ExAeonsEnd.Card{id: 42, name: "x"}, %ExAeonsEnd.Card{id: 43, name: "y"}], discard: []}

  iex> alias ExAeonsEnd.{Deck, Card}
  ...> pile = [%Card{id: 42, name: "x"}, %Card{id: 43, name: "y"}]
  ...> ExAeonsEnd.Deck.new |> ExAeonsEnd.Deck.set_pile(:discard, pile)
  %ExAeonsEnd.Deck{discard: [%ExAeonsEnd.Card{id: 42, name: "x"}, %ExAeonsEnd.Card{id: 43, name: "y"}], draw: []}
  """
  @spec set_pile(__MODULE__.t(), __MODULE__.pile(), list(Card.t())) :: __MODULE__.t()
  def set_pile(deck, pile_type, new_pile)

  def set_pile(deck, :draw, new_draw), do: %__MODULE__{deck | draw: new_draw}
  def set_pile(deck, :discard, new_discard), do: %__MODULE__{deck | discard: new_discard}
end
