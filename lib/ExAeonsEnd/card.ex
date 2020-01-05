defmodule ExAeonsEnd.Card do
  @moduledoc "
  This is a simple structure that represents a card

  At first pass, this is just a turn order card. This may eventually be refactored
  to either support other types of cards, or be renamed to indicate that it is just
  for turn order.
  "

  defstruct [:id, :name]

  @type t :: %__MODULE__{
          id: integer(),
          name: String.t()
        }

  @doc """
  This function takes a list of cards and tries to find the first instance of a
  specific card.

  If it finds it, it will return a tuple with that card and the list without the card.

  If it doesn't find it, then it will return a tuple with an error

  ## Examples -- by card

  iex> [] |> ExAeonsEnd.Card.take_card(%ExAeonsEnd.Card{id: 1, name: "test"})
  {:error, :not_found}

  iex> [%ExAeonsEnd.Card{id: 1, name: "a"}, %ExAeonsEnd.Card{id: 2, name: "b"}] |> ExAeonsEnd.Card.take_card(%ExAeonsEnd.Card{id: 1, name: "a"})
  {%ExAeonsEnd.Card{id: 1, name: "a"}, [%ExAeonsEnd.Card{id: 2, name: "b"}]}

  iex> [%ExAeonsEnd.Card{id: 1, name: "a"}, %ExAeonsEnd.Card{id: 1, name: "a"}] |> ExAeonsEnd.Card.take_card(%ExAeonsEnd.Card{id: 1, name: "a"})
  {%ExAeonsEnd.Card{id: 1, name: "a"}, [%ExAeonsEnd.Card{id: 1, name: "a"}]}

  iex> [%ExAeonsEnd.Card{id: 1, name: "a"}, %ExAeonsEnd.Card{id: 2, name: "b"}] |> ExAeonsEnd.Card.take_card(%ExAeonsEnd.Card{id: 2, name: "b"})
  {%ExAeonsEnd.Card{id: 2, name: "b"}, [%ExAeonsEnd.Card{id: 1, name: "a"}]}

  ## Examples -- by index

  iex> [%ExAeonsEnd.Card{id: 1, name: "a"}, %ExAeonsEnd.Card{id: 2, name: "b"}] |> ExAeonsEnd.Card.take_card(0)
  {%ExAeonsEnd.Card{id: 1, name: "a"}, [%ExAeonsEnd.Card{id: 2, name: "b"}]}

  iex> [%ExAeonsEnd.Card{id: 1, name: "a"}, %ExAeonsEnd.Card{id: 2, name: "b"}] |> ExAeonsEnd.Card.take_card(1)
  {%ExAeonsEnd.Card{id: 2, name: "b"}, [%ExAeonsEnd.Card{id: 1, name: "a"}]}
  """
  @spec take_card([__MODULE__.t()], __MODULE__.t() | integer()) ::
          {__MODULE__.t(), [__MODULE__.t()]} | {:error, :not_found}
  def take_card(cards, expected_card)

  def take_card(cards, card_index) when is_integer(card_index),
    do: take_card_by_index(card_index, cards)

  def take_card(cards, expected_card) do
    cards
    |> Enum.find_index(fn x -> x == expected_card end)
    |> take_card_by_index(cards)
  end

  defp take_card_by_index(nil, _cards), do: {:error, :not_found}

  defp take_card_by_index(index, cards)
       when is_integer(index) and index >= 0 and index < length(cards) do
    {front, [card | back]} = cards |> Enum.split(index)

    remainder = Enum.concat(front, back)
    {card, remainder}
  end
end
