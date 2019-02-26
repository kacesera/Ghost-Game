require_relative 'game'

system("clear")
puts "Let's play a game of Ghost!"
puts "----------------------------"
sleep(1)


puts "Enter number of players (at least 2):"
number_of_players = gets.chomp.to_i
if number_of_players < 2
    raise "ERROR! Minimum number is 2."
elsif number_of_players > 6
    raise "ERROR! Too many players! Lose some friends."
else
    ghost = Ghost_game.new(number_of_players)
    ghost.get_players
    sleep(2)
end

until ghost.game_over? do
    ghost.play_round
end

puts "Game over! #{ghost.winner} wins!"
sleep(5)
system("clear")
