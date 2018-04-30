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

  def getScoreByDice(index, size)
    mappingScore = {
      1 => [1000, 100],
      6 => [600, 0],
      5 => [500, 50],
      4 => [400, 0],
      3 => [300, 0],
      3 => [300, 0],
      2 => [200, 0]
    }
    (size / 3) * mappingScore[index][0] + (size % 3) * mappingScore[index][1]
  end
  
  def calculateScore(diceSet)
    groupedDice = diceSet.group_by{|i| i}
    totalScore = 0
    groupedDice.each {|key, values| totalScore += getScoreByDice(key, values.size)}
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
