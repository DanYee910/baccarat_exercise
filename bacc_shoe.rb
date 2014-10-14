#pseudocode

# 1.def class shoe.  i want to create a "shoe" object containing 8 decks of 52 cards each.  Do not need suits, only the values.
# 2.shoe needs to be shuffled
# 3.when the shoe size is less than 50 cards, it is recreated and reshuffled.
# 4.the shoe needs a method to remove a single card from the front

CARD_VALS = "23456789TJQKA"

class CardShoe
  attr_reader :shoe
  def initialize(num_decks)
    @num_decks = num_decks
    @shoe = gen_new_shoe
  end

  def gen_new_shoe
    @shoe = (CARD_VALS * 4 * @num_decks).split("").each {|card| card.gsub!("T", "10")}
    @shoe.shuffle!
  end

  def shoe_running_low
    if shoe_card_count < 50
      puts "Changing to a new shoe"
      gen_new_shoe
    end
  end

  def shoe_card_count
    @shoe.size
  end

  def deal_one_card
    @shoe.shift
  end
end

#driver tests
shoe = CardShoe.new(2)
p shoe.shoe
p shoe.shoe.count == 104
shoe.shoe.pop(60)
p shoe.shoe.count
shoe.shoe_running_low
p shoe.shoe.count
p shoe.shoe.count("K") == 8
p shoe.shoe.count("3") == 8
p shoe.shoe.count("10") == 8