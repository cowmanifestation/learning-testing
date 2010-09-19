require "test/unit"
require "rubygems"
require "contest"
require "deck"

class CardTest < Test::Unit::TestCase
  test "should have a suit and a value" do
    card = Onzie::Card.new("clubs", 3)
    assert_equal "clubs", card.suit
    assert_equal 3, card.value
  end

  test "wild cards should be 20 points" do
    wild_card = Onzie::Card.new("clubs", 2)
    assert_equal 20, wild_card.points
  end

  test "aces should be 15 points" do
    ace = Onzie::Card.new("clubs", "A")
    assert_equal 15, ace.points
  end

  test "face cards should be 10 points" do
    face_card = Onzie::Card.new("clubs", "Q")
    assert_equal 10, face_card.points
  end

  test "all other cards should be 5 points" do
    card = Onzie::Card.new("clubs", 3)
    assert_equal 5, card.points
  end
end
    
class DeckTest < Test::Unit::TestCase
  test "should have 52 cards" do
    deck = Onzie::Deck.new
    assert_equal 52, deck.cards.size
  end

  test "should be able to shuffle deck" do
    deck = Onzie::Deck.new
    sorted_cards = (0..7).map {|i| deck.cards[i]}
    shuffled_cards = (0..7).map {|i| deck.shuffle[i]}
    assert_not_equal sorted_cards, shuffled_cards
  end

  test "should be able to draw a card" do
    deck = Onzie::Deck.new
    card = deck.draw[0]

    assert_equal "2", card.value
  end

  test "should be able to draw multiple cards" do
    deck = Onzie::Deck.new
    hand = deck.draw(7).map {|c| c.value}
    
    assert_equal 7, hand.size
    assert_equal %w[2 3 4 5 6 7 8], hand
  end
end

class DiscardPileTest < Test::Unit::TestCase
  
  test "should be able to see top card" do
    dp = Onzie::DiscardPile.new
    dp.cards = ["card1", "card2", "card3"]

    assert_equal "card1", dp.show
  end

  test "should be able to add a card to discard pile" do
    dp = Onzie::DiscardPile.new

    dp << "card1"
    assert_equal "card1", dp.show
  end
  
  test "most recently added card should always be on top" do
    dp = Onzie::DiscardPile.new
    dp << "card1"
    dp << "card2"
    dp << "card3"

    assert_equal "card3", dp.show
  end
end
