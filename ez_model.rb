CARD_VALS = "23456789TJQKA"
VALUES = {"2"=> 2, "3"=> 3, "4"=> 4, "5"=> 5, "6"=> 6, "7"=> 7, "8"=> 8, "9"=> 9, "10"=> 0, "J"=> 0, "Q"=> 0, "K"=> 0, "A"=> 1}
PAYOUTS = {"bet" => 1, "tie" => 9, "dragon" => 40, "panda" => 25}

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

class Player
  def initialize
    @money = 0
    @total_deposit = 0
  end

  def money
    puts "You have $#{@money} left."
  end

  def deposit(num)
    puts "Cashing in for $#{num} of chips."
    @money += num
    @total_deposit += num
  end

  def total_in_for
    puts "You have deposited a total of $#{@total_deposit}."
  end

  def place_bets_on_table(num)
    @money -= num
  end

  def collect_wins(num)
    @money += num
  end
end

class PlayGame
  attr_reader :banker_cards, :player_cards
  def initialize
    @bets_on_table = {:b_bet => 0,:p_bet => 0, :tie => 0, :dragon => 0, :panda => 0}
    @outcomes = {:b_bet => false,:p_bet => false, :tie => false, :dragon => false, :panda => false}
    @banker_cards = []
    @player_cards = []
    @b_score = 0
    @p_score = 0
  end

  def ask_for_bets
    View.ask_base_bet
    which_side = gets.chomp
    View.how_much_bet
    wager = gets.chomp
    View.confirm_bet(wager, which_side)
    @bets_on_table[:b_bet] = wager if which_side == "B"
    @bets_on_table[:p_bet] = wager if which_side == "P"
    View.ask_tie
    @bets_on_table[:tie] = gets.chomp
    View.ask_dragon
    @bets_on_table[:dragon] = gets.chomp
    View.ask_panda
    @bets_on_table[:panda] = gets.chomp
    sleep(0.5)
    p @bets_on_table.values.map! {|bet| bet.to_i}
    View.all_bets_placed
    #.values.inject(:+)
  end

  def view_bets
    puts @bets_on_table
  end

  def deal_cards(shoe)
    hit_player(shoe)
    hit_banker(shoe)
    hit_player(shoe)
    hit_banker(shoe)
    if !natural?
      hit_third_player?(shoe)
      hit_third_banker?(shoe)
    end
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
      banker_hit_chart(shoe)
    end
  end

  def banker_hit_chart(shoe)
    pv = VALUES[@player_cards[2]]
    c = calculate_score(@banker_cards)
    (c == 3 && pv != 8) ? hit_banker(shoe) :
    (c == 4 && (2..7).include?(pv)) ? hit_banker(shoe) :
    (c == 5 && (4..7).include?(pv)) ? hit_banker(shoe) :
    (c == 6 && (6..7).include?(pv)) ? hit_banker(shoe) :
    c < 3 ? hit_banker(shoe) : nil;
  end

  def calculate_score(p_or_b)
    temp = 0
    p_or_b.each {|card| temp += VALUES[card]}
    temp % 10
  end

  def determine_outcome
    @p_score > @b_score ? @outcomes[:p_bet] = true :
    @b_score > @p_score ? @outcomes[:b_bet] = true : @outcomes[:tie] = true
  end

  def dragon?
    @banker_cards.size == 3 && calculate_score(@banker_cards) == 7
  end

  def panda?
    @player_cards.size == 3 && calculate_score(@player_cards) == 8
  end

  def winning_bets
    if @outcomes[:p_bet] = true
      @outcomes[:panda] = true if panda?
    elsif @outcomes[:b_bet] = true
      @outcomes[:dragon] = true if dragon?
    else
      @outcomes[:tie] = true
    end
  end
end

class BetResolver
  def money_won(bets, outcomes)
    money_back = []

    banker = (bets[:b_bet] * (1 + PAYOUTS["bet"])) if outcomes[:b_bet] == true
    player = (bets[:p_bet] * (1 + PAYOUTS["bet"])) if outcomes[:p_bet] == true
    tie = (bets[:tie] * (1 + PAYOUTS["tie"])) if outcomes[:tie] == true
    dragon = (bets[:dragon] * (1 + PAYOUTS["dragon"])) if outcomes[:dragon] == true
    panda = (bets[:panda] * (1 + PAYOUTS["panda"])) if outcomes[:panda] == true

    (money_back.push(banker, player, tie, dragon, panda) - [nil]).inject(:+)
  end
end

class View
  def self.ask_base_bet
    puts "Please place all bets in increments of $5:"
    puts "Place a base bet on Banker or Player.  Enter 'B' or 'P' to choose."
  end
  def self.how_much_bet
    puts "How much would you like to bet?"
  end
  def self.confirm_bet(wager, which_side)
    puts "You are betting $#{wager} on #{which_side}"
  end
  def self.ask_tie
    puts "Please bet at least 0 on the TIE bonus bet"
  end
  def self.ask_panda
    puts "Please bet at least 0 on the PANDA bonus bet"
  end
  def self.ask_dragon
    puts "Please bet at least 0 on the DRAGON bonus bet"
  end
  def all_bets_placed
    puts "All bets placed, ready to deal!"
  end
end