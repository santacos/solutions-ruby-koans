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
	attr_accessor :score, :name
	def initialize(name, scoreCalculator)
		@diceThrowes = []
    @score = 0
    @name = name
    @scoreCalculator = scoreCalculator
	end

  def play(number)
    newDiceSet = DiceSet.new.roll(number)
    @diceThrowes << newDiceSet
    @score = @score + @scoreCalculator.calculate(newDiceSet)
    newDiceSet
  end
end

class ScoreCalculator 
  def getScoreByDice(index, size)
    mappingScore = {
      1 => [1000, 100],
      6 => [600, 0],
      5 => [500, 50],
      4 => [400, 0],
      3 => [300, 0],
      2 => [200, 0]
    }
    (size / 3) * mappingScore[index][0] + (size % 3) * mappingScore[index][1]
  end
  
  def calculate(diceSet)
    diceSet.group_by{|i| i}.reduce(0) {
      |acc, (key, values)| acc + getScoreByDice(key, values.size)
    }
  end
end

class Game
  attr_reader :players

  def initialize
    @scoreCalculator = ScoreCalculator.new
  end

	def start
		puts "The game starts."
    puts "How many players do we have? (2/3/4)"
    numberOfPlayers = (gets).to_i
    initialize_players(numberOfPlayers)
    puts "Now we get #{@players.size} players"
    
    isFoundWinner = false
    while !isFoundWinner do
      @players.each do |player, index|
        puts "Current player: #{player.name}"
        newDiceSet = player.play(5)
        puts "Enter to throw the dice"
        gets
        puts "You got #{newDiceSet}"
        puts "Your score for this round is #{player.score}"
        if score >= 3000
          isFoundWinner = true
          puts "Congratulation!! You're the winner #{player.name}"
          break
        end
      end
    end
  end

  def initialize_players(number)
    @players = (1..number).map { |index| index = Player.new(index, @scoreCalculator) } 
  end
end

class ExtraTestCase < Neo::Koan
  def test_calculate_score_of_player
    sampleGame = ScoreCalculator.new
    assert_equal sampleGame.calculate([1,1,1]), 1000
    assert_equal sampleGame.calculate([1,1,1,1,1,1]), 2000
    assert_equal sampleGame.calculate([1,1,1,1]), 1100
    assert_equal sampleGame.calculate([1,1,1,1,1]), 1200
    assert_equal sampleGame.calculate([6,6,6]), 600
    assert_equal sampleGame.calculate([5,5,5]), 500
    assert_equal sampleGame.calculate([4,4,4]), 400
    assert_equal sampleGame.calculate([3,3,3]), 300
    assert_equal sampleGame.calculate([3,3,3,1,5]), 300 + 100 + 50
	end
end

# Game.new.start
