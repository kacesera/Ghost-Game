
class Player
    attr_reader :name

    def initialize(name)
        @name = name.upcase
    end 

    def guess
        puts 'Enter a letter:'
        gets.chomp
    end 

    def alert_invalid_guess
        puts "----------------------------"
        puts 'Entry was invalid! Try again! :( '
        puts "----------------------------"
    end
end