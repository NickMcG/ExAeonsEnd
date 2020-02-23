defmodule ExAeonsEnd.PlayerTurnDeck do
  @moduledoc "This module represents the player turn deck."

  use GenServer

  alias ExAeonsEnd.{Card, Deck}

  ### Public Interface
  @spec start_link(1 | 2 | 3 | 4 | [String.t()]) :: :ignore | {:error, any()} | {:ok, pid}
  def start_link(players), do: start_link(players, false)

  @spec start_link(1 | 2 | 3 | 4 | [String.t()], boolean()) :: :ignore | {:error, any()} | {:ok, pid}
  def start_link(players, include_assault) do
    player_cards = create_player_cards_for(players, include_assault)
    deck = %Deck{draw: player_cards, discard: []} |> Deck.shuffle()

    GenServer.start_link(__MODULE__, deck)
  end

  @spec draw(pid()) :: Card.t()
  def draw(pid), do: GenServer.call(pid, :draw)

  @spec shuffle(pid()) :: :ok
  def shuffle(pid), do: GenServer.call(pid, :shuffle)

  @spec view_draw(pid()) :: list(Card.t())
  def view_draw(pid), do: GenServer.call(pid, :view_draw)

  @spec view_discard(pid()) :: list(Card.t())
  def view_discard(pid), do: GenServer.call(pid, :view_discard)

  @spec move_card_from_discard(pid(), Card.t()) :: :ok | {:error, any()}
  def move_card_from_discard(pid, card), do: GenServer.call(pid, {:move_card_from_discard, card})

  @spec set_draw(pid(), list(Card.t())) :: :ok
  def set_draw(pid, draw_pile), do: GenServer.call(pid, {:set_draw, draw_pile})

  ### GenServer Callbacks

  @impl true
  def init(deck), do: {:ok, deck}

  @impl true
  def handle_call(:draw, _from, deck) do
    {card, updated_deck} = deck |> Deck.draw() |> handle_draw()
    {:reply, card, updated_deck |> Deck.add_card(:discard, card)}
  end

  @impl true
  def handle_call(:shuffle, _from, deck), do: {:reply, :ok, deck |> Deck.shuffle()}

  @impl true
  def handle_call(:view_draw, _from, deck), do: {:reply, deck.draw, deck}

  @impl true
  def handle_call(:view_discard, _from, deck), do: {:reply, deck.discard, deck}

  @impl true
  def handle_call({:move_card_from_discard, card}, _from, deck) do
    deck.discard
    |> Card.take_card(card)
    |> handle_move_from_discard(deck)
  end

  @impl true
  def handle_call({:set_draw, draw_pile}, _from, deck),
    do: {:reply, :ok, %Deck{deck | draw: draw_pile}}

  ### Private Interface
  @p1 "Player 1"
  @p2 "Player 2"
  @p3 "Player 3"
  @p4 "Player 4"
  @w "Wild"
  @n "Nemesis"
  @a "Nemesis - Assault"

  defp create_player_cards(p1, p2, p3, p4, true),
    do: [
      %Card{id: 1, name: p1},
      %Card{id: 2, name: p2},
      %Card{id: 3, name: p3},
      %Card{id: 4, name: p4},
      %Card{id: 5, name: @n},
      %Card{id: 6, name: @a}
    ]

  defp create_player_cards(p1, p2, p3, p4, false),
    do: [
      %Card{id: 1, name: p1},
      %Card{id: 2, name: p2},
      %Card{id: 3, name: p3},
      %Card{id: 4, name: p4},
      %Card{id: 5, name: @n},
      %Card{id: 6, name: @n}
    ]

  defp create_player_cards_for([p1], include_assault), do: create_player_cards(p1, p1, p1, p1, include_assault)
  defp create_player_cards_for([p1, p2], include_assault), do: create_player_cards(p1, p1, p2, p2, include_assault)
  defp create_player_cards_for([p1, p2, p3], include_assault), do: create_player_cards(p1, p2, p3, @w, include_assault)
  defp create_player_cards_for([p1, p2, p3, p4], include_assault), do: create_player_cards(p1, p2, p3, p4, include_assault)

  defp create_player_cards_for(1, include_assault), do: create_player_cards(@p1, @p1, @p1, @p1, include_assault)
  defp create_player_cards_for(2, include_assault), do: create_player_cards(@p1, @p1, @p2, @p2, include_assault)
  defp create_player_cards_for(3, include_assault), do: create_player_cards(@p1, @p2, @p3, @w, include_assault)
  defp create_player_cards_for(4, include_assault), do: create_player_cards(@p1, @p2, @p3, @p4, include_assault)

  defp handle_draw({:empty, deck = %Deck{discard: discard}}) when length(discard) > 0 do
    # Draw is empty, but discard isn't, so move discard to draw and shuffle
    %Deck{deck | draw: discard, discard: []}
    |> Deck.shuffle()
    |> Deck.draw()
  end

  defp handle_draw({card = %Card{}, deck = %Deck{}}), do: {card, deck}

  defp handle_move_from_discard(result = {:error, _err}, deck), do: {:reply, result, deck}

  defp handle_move_from_discard({card = %Card{}, discard}, deck) do
    {:reply, :ok, %Deck{deck | discard: discard, draw: [card | deck.draw]}}
  end
end
