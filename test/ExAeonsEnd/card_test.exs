defmodule ExAeonsEnd.CardTest do
  use ExUnit.Case
  doctest ExAeonsEnd.Card
  alias ExAeonsEnd.Card

  test "indexing out of bounds" do
    cards = [%Card{id: 1, name: "a"}, %Card{id: 2, name: "b"}]

    assert_raise FunctionClauseError, fn ->
      Card.take_card(cards, 2)
    end
  end

  test "indexing less than 0" do
    cards = [%Card{id: 1, name: "a"}, %Card{id: 2, name: "b"}]

    assert_raise FunctionClauseError, fn ->
      Card.take_card(cards, -2)
    end
  end
end
