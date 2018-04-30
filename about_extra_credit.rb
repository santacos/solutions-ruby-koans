require File.expand_path(File.dirname(__FILE__) + '/neo')
# EXTRA CREDIT:
#
# Create a program that will play the Greed Game.
# Rules for the game are in GREED_RULES.TXT.
#
# You already have a DiceSet class and score function you can use.
# Write a player class and a Game class to complete the project.  This
# is a free form assignment, so approach it however you desire.
class DiceSet
	attr_reader :values
	def roll(number)
		@values = (1..number).map { |x| x = rand(1..6) }
	end
	@values
end

class Player
	attr_reader :diceThrowes
	attr_accessor :score
	def initialize
		@diceThrowes = []
		@score = 0
	end

	def play(number)
		@diceThrowes << DiceSet.new.roll(number)
	end
end

class Game
	attr_reader :players
	def start
		puts "The game starts."
		puts "How many players do we have? (2/3/4)"
    numberOfPlayers = (gets).to_i
    set_players(numberOfPlayers)
		puts "Now we get #{@players.size} players"
		1
  end

  def set_players(number)
    @players = (1..number).map { |index| index = Player.new } 
  end
  
  def calculateScore(diceSet)
    groupedDice = diceSet.group_by{|i| i}
    totalScore = 0
    if (groupedDice[1] != nil)
      totalScore += (groupedDice[1].size / 3) * 1000 + (groupedDice[1].size % 3) * 100
    end
    if (groupedDice[6] != nil)
      totalScore += (groupedDice[6].size / 3) * 600
    end
    if (groupedDice[5] != nil)
      totalScore += (groupedDice[5].size / 3) * 500 + (groupedDice[5].size % 3) * 50
    end
    if (groupedDice[4] != nil)
      totalScore += (groupedDice[4].size / 3) * 400
    end
    if (groupedDice[3] != nil)
      totalScore += (groupedDice[3].size / 3) * 300
    end
    if (groupedDice[2] != nil)
      totalScore += (groupedDice[2].size / 3) * 200
    end

    totalScore
  end
end

class ExtraTestCase < Neo::Koan
  def test_calculate_score_of_player
    sampleGame = Game.new
    assert_equal sampleGame.calculateScore([1,1,1]), 1000
    assert_equal sampleGame.calculateScore([1,1,1,1,1,1]), 2000
    assert_equal sampleGame.calculateScore([1,1,1,1]), 1100
    assert_equal sampleGame.calculateScore([1,1,1,1,1]), 1200
    assert_equal sampleGame.calculateScore([6,6,6]), 600
    assert_equal sampleGame.calculateScore([5,5,5]), 500
    assert_equal sampleGame.calculateScore([4,4,4]), 400
    assert_equal sampleGame.calculateScore([3,3,3]), 300
    assert_equal sampleGame.calculateScore([3,3,3,1,5]), 300 + 100 + 50
	end
end

# Game.new.start
