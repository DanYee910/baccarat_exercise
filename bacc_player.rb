#pseudocode

# 1. I want a player class
# 2. initialize with 0 money, attribute is @money
# 3. need a method that deposits money
# 4. need a method that keeps track of all money deposited, max 20,000
# 5. player needs a mtheod to place bets, in increments of 5, max 2,000 per hand

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

  def bet

  end
end

# a = Player.new
# p a.deposit(5000)
# a.deposit(2000)
# a.deposit(100)
# a.total_in_for