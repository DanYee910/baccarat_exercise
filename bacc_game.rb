=begin
pseudocode

1.define play hand class
2.to play a single hand:
3.first prepare shoe
4.ask pplayer for bets
5.deal first 4 cards, check for natural. if natural, resolve winner/tie
6.if no, check if deal 3rd player card
7.if no 3rd player card, banker 3rd card hits house way, if yes then hit chart
=end

require_relative 'bacc_player.rb'
require_relative 'bacc_shoe.rb'

PAYOUTS = {"bet" => 1, "tie" => 9, "dragon" => 40, "panda" => 25}

class PlayGame
  attr_reader :banker_cards, :player_cards
  def initialize
    @bets_on_table = {:b_bet => 0,:p_bet => 0, :tie => 0, :dragon => 0, :panda => 0}
    @banker_cards = ["2", "2"]
    @player_cards = ["3", "A", "6"]
    @b_score = 0
    @p_score = 0
  end

  def ask_for_bets
    puts "Please place all bets in increments of $5:"
    puts "Place a base bet on Banker or Player.  Enter 'B' or 'P' to choose."
    which_side = gets.chomp
    puts "How much would you like to bet?"
    wager = gets.chomp
    puts "You are betting $#{wager} on #{which}"
    @bets_on_table[:b_bet] = wager if which_side == "B"
    @bets_on_table[:p_bet] = wager if which_side == "P"
    puts "Please bet at least 0 on the TIE bonus bet"
    @bets_on_table[:tie] = gets.chomp
    puts "Please bet at least 0 on the DRAGON bonus bet"
    @bets_on_table[:dragon] = gets.chomp
    puts "Please bet at least 0 on the PANDA bonus bet"
    @bets_on_table[:panda] = gets.chomp
    sleep(0.5)
    puts "All bets placed, ready to deal!"
  end

  def view_bets
    puts @bets_on_table
  end

  def deal_cards(shoe)
    hit_player(shoe)
    hit_banker(shoe)
    sleep(0.5)
    hit_player(shoe)
    sleep(0.25)
    hit_banker(shoe)
    if natural?

    end
    hit_third_player?
    hit_third_banker?
  end

  def hit_banker(shoe)
    @banker_cards << shoe.deal_one_card
  end

  def hit_player(shoe)
    @player_cards << shoe.deal_one_card
  end

  def natural?
    calculate_score(@banker_cards) >= 8 || calculate_score(@player_cards) >= 8
  end

  def hit_third_player?(shoe)
    hit_player(shoe) if calculate_score(@player_cards) <= 5
  end

  def hit_third_banker?(shoe)
    if @player_cards.size == 2
      if calculate_score(@banker_cards) <= 5
        hit_banker(shoe)
      end
    else
      #hit chart

    end
  end

  def banker_hit_chart(shoe)
    pv = VALUES[@player_cards[2]]
    c = calculate_score(@banker_cards)
    case c
    when c == 3
      hit_banker(shoe) if pv != 8
    when c == 4
      hit_banker(shoe) if (2..7).include?(pv)
    when c == 5
      hit_banker(shoe) if (4..7).include?(pv)
    when c == 6
      hit_banker(shoe) if (6..7).include?(pv)
    when c > 6
    else
      hit_banker(shoe)
    end
  end


# grade = gets.chomp
# case grade
# when "A"
#   puts 'Well done!'
# when "B"
#   puts 'Try harder!'
# when "C"
#   puts 'You need help!!!'
# else
#   puts "You just making it up!"
# end

  def calculate_score(p_or_b)
    temp = 0
    p_or_b.each {|card| temp += VALUES[card]}
    temp % 10
  end

  def determine_outcome
    @p_score > @b_score ? "Player" :
    @b_score > @p_score ? "Banker" : "TIE"
  end

  def dragon?
    @banker_cards.size == 3 && calculate_score(@banker_cards) == 7
  end

  def panda?
    @player_cards.size == 3 && calculate_score(@player_cards) == 8
  end

  def resolve_base_bets

  end

  def resolve_bonus_bets

  end
end

s = CardShoe.new(2)
g = PlayGame.new
# g.view_bets
# g.ask_for_bets
# g.view_bets

# p g.natural?
# p g.hit_third_player?
# p g.determine_outcome
# g.banker_hit_chart
# p g.hit_banker(s)
# p g.banker_cards
# p g.player_cards
