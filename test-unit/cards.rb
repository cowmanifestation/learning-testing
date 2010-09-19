module Onzie
  class Card < Struct.new(:suit, :value)
    def wild?
      case value
      when "2"
        true
      when 2
        true
      else
        false
      end
    end

    def face_card?
      ["J", "Q", "K"].include?(value)
    end

    def ace?
      value == "A"
    end

    def points
      if self.wild?
        20
      elsif self.face_card?
        10
      elsif self.ace?
        15
      else
        5
      end
    end
  end

  class Deck
    include Enumerable

    def initialize
      @cards = []
      
      %w[S D H C].each do |suit|
        %w[2 3 4 5 6 7 8 9 10 J Q K A].each do |value|
          @cards << Card.new(suit, value)
        end
      end

      @cards
    end

    attr_accessor :cards

    def shuffle
      self.cards = cards.sort_by { rand }
    end

    def each
      @cards.each { |card| yield(card)  }
    end

    def draw(n=1)
      (1..n).map{self.cards.shift}
    end

  end

  class DiscardPile < Deck
    def initialize
      @cards = []
    end

    def <<(card)
      self.cards.unshift(card)
    end

    def draw
      self.cards.shift
    end

    def show
      self.cards.first
    end
  end
end
