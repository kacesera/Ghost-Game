require_relative 'player'
require 'byebug'

class Ghost_game
    MAX_LOSS_COUNT = 5

    attr_reader :losses, :fragment, :players, :dictionary, :round_count,
    :number_of_players

    def initialize(number_of_players)
        @words = File.readlines("dictionary.txt").map(&:chomp)
        @number_of_players = number_of_players
        @players = []
        @dictionary = Set.new(words)
        @fragment = ""
        @losses = Hash.new(0)
        @round_count = 1
    end 

    def get_players
        (1..@number_of_players).each do |num|
            puts
            puts "Player #{num}, enter name:"
            name = gets.chomp
            @players << Player.new(name)
        end
        puts
        puts "Alright! Are you ready? Round 1!"
        sleep (1)
    end

    def game_over?
        remaining_players == 1
    end 

    def remaining_players
        count = 0
        losses.each do |player, losses|
            if losses < MAX_LOSS_COUNT
                count += 1
            end
        end
        count
    end       

    def play_round
        @fragment = ""
        self.display_standings
        until self.round_over?
            self.take_turn
        end
        self.update_standings
        @round_count += 1
    end

    def record(player)
        count = @losses[player]
        if count >= 1
            new_count = count - 1
            'GHOST'.slice(0..new_count)
        end
    end 

    def winner
        winner = current_player.name
    end

    def current_player
        @players.first
    end

    def previous_player
        @players.last
    end

    def next_player!
        players.rotate!
        players.rotate! until losses[current_player] < MAX_LOSS_COUNT 
    end

    def valid_play?(letter)
        alphabet = "abcdefghijklmnopqrstuvwxyz"
        return false unless alphabet.include?(letter.downcase)
        potential = @fragment + letter.downcase

        dictionary.any? {|word| word.start_with?(potential)}
    end

    def is_word?(string)
        dictionary.include?(fragment)
    end

    def round_over?
        is_word?(fragment)
    end

    def take_turn 
        puts
        letter = nil
        until letter
            puts "--> It\'s #{current_player.name}'s turn! <--"
            letter = current_player.guess.downcase
            if !valid_play?(letter)
                current_player.alert_invalid_guess
                letter = nil
            else
                @fragment += letter
            end
        end

        puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
        puts "WORD: #{fragment}"
        puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~"

        self.next_player! 
    end 

    def display_standings
        system("clear")
        puts "Round #{round_count}"
        puts "----------------------------"
        puts "Current score:"
        players.each do |player|
            puts "#{player.name}: #{record(player)}"
        end 
    end

    def update_standings
        puts "#{previous_player.name} spelled #{@fragment}!"
        puts "#{previous_player.name} gets a letter."
        losses[previous_player] += 1
        losses[current_player] += 0
        puts "----------------------------"

        if losses[previous_player] == MAX_LOSS_COUNT
            puts "#{previous_player.name} has been eliminated!"
        end 
        puts "----------------------------"
        sleep(2)
    end 
end 
