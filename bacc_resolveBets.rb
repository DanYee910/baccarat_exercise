#get back the results of bets that won and lost.
#calculate the money paid out for each bet
#set money to 0 for bets lost
#return all numbers in the array into players bank


# @bets_on_table = {:b_bet => 0,:p_bet => 0, :tie => 0, :dragon => 0, :panda => 0}
# @outcomes = {:b_bet => false,:p_bet => false, :tie => false, :dragon => false, :panda => false}

PAYOUTS = {"bet" => 1, "tie" => 9, "dragon" => 40, "panda" => 25}

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

calc = BetResolver.new
bets_on_table = {:b_bet => 0,:p_bet => 10, :tie => 5, :dragon => 10, :panda => 5}
outcomes = {:b_bet => false,:p_bet => true, :tie => false, :dragon => false, :panda => false}
p calc.money_won(bets_on_table, outcomes)