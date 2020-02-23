defmodule ExAeonsEnd do
  @moduledoc """
  This is a helper module to make handling turn order easier.
  """

  alias ExAeonsEnd.PlayerTurnDeck

  def start do
    {:ok, pid} = PlayerTurnDeck.start_link(2)
    pid
  end

  def start_legacy, do: start_legacy(false)

  def start_legacy(include_assault) do
    {:ok, pid} = PlayerTurnDeck.start_link(["Nick", "Amanda"], include_assault)
    pid
  end

  def draw(pid) do
    card = PlayerTurnDeck.draw(pid)

    discard =
      pid
      |> PlayerTurnDeck.view_discard()
      |> Enum.map(fn x -> x.name end)
      |> Enum.join(", ")

    IO.puts("-- Discard: #{discard}")

    card.name
  end

  def view_draw(pid), do: pid |> PlayerTurnDeck.view_draw()

  def reorder_mage_power(pid, new_draw), do: pid |> PlayerTurnDeck.set_draw(new_draw)

  def view_discard(pid), do: pid |> PlayerTurnDeck.view_discard()

  def shuffle_discard_card_into_draw(pid, card) do
    :ok = pid |> PlayerTurnDeck.move_card_from_discard(card)
    pid |> PlayerTurnDeck.shuffle()
  end
end
