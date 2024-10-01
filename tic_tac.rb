module TicTacToe 
  WINS = [[1,2,3],[4,5,6],[7,8,9],[1,4,7],[2,5,8],[3,6,9],[1,5,9],[3,5,7]]
  class Game 
    def initialize(player_1_class, player_2_class)
      @board = Array.new(10)
      @current_player_id = 0 
      @players = [player_1_class.new(self, "X"), players_2_class.new(self,"O")]
      puts "#{current_player} starts"
    end 

    attr_reader :board, :current_player_id

    def free_positions
      (1..9).select {|position| @board[position].nil?}
    end 

    def place_player_marker(player)
      position = player.select_position!
      puts "#{player} set to #{player.marker} to #{position}"
      @bord[position] = player.marker 
    end 

    def player_has_won?(player)
      WINS.any? do |win|
        win.all? {|position| @board[position] == player.marker}
      end 
    end 

    def board_full?
      free_positions.empty?
    end 

    def other_player_id 
      1 - @current_player_id
    end 

    def switch_players!
      @current_player_id = other_player_id
    end 

    def current_player
      @players[current_player_id]
    end 

    def opponent 
      @players[other_player_id]
    end 

    def turn_num 
      10 - free_positions.size 
    end 
    
    def play 
      loop do
        place_player_marker(current_player)
        if player_has_won?(current_player)
          puts "#{current_player} wins!"
          print_board 
          return  
        elsif board_full?
          puts "It's a tie!"
          print_board 
          return 
        end 
          
        switch_players!
      end 
    end 

    def print_board
      puts "     |     |      "
      puts "  #{board[1]}  |  #{board[2]}  |  #{board[3]}  "
      puts "_____|_____|_____ "
      puts "     |     |      "
      puts "  #{board[4]}  |  #{board[5]}  |  #{board[6]}  "
      puts "_____|_____|_____ "
      puts "     |     |      "
      puts "  #{board[7]}  |  #{board[8]}  |  #{board[9]}  "
      puts "     |     |      "
    end 
  end 

  class Player 
    def initialize(game, marker)
      @game = game 
      @marker = marker 
    end 
    attr_reader  :marker
  end 

  class HumanPlayer < Player 
    def select_position
      @game.print_board 
      loop do 
        print "Select your #{marker} position"
        position = gets.chomp.to_i 
        return position if @game.free_positions.include?(position)
        puts "Invalid position. Try again."
      end
    end
    
    def to_s 
      "Human"
    end 
  end 

  class ComputerPlayer < Player 
    def group_positions_by_markers(line)
      markers = line.group_by {|position| @game.board[position]}
      markers.default = []
      markers 
    end 
    
    def select_position
      opponent_marker = @game.opponent.marker

      win_or_block_position = look_for_win_or_block(opponent_marker)
      return win_or_block_position if win_or_block_position

      if corner_trap?
        return corner_trap_position(opponent_marker)
      end 

      return random_position
    end

    def look_for_win_or_block(opponent_marker)
      for win in WINS 
        markers = group_positions_by_markers(win)
        next if markers[nil].length != 1
        if markers[self.marker].length == 2
          log_debug "winning on line #{line.join}"
          return markers[nil].first
        elsif markers[opponent_marker].length == 2
          log_debug "could block on line #{line.join}"
          blocking_position = markers[nil].first
        end
      end
      if blocking_position
        log_debug "blocking at #{blocking_position}"
        return blocking_position
      end
    end 

    def corner_trap?
      corner_positions = [1, 3, 7, 9]
      opponent_chose_a_corner = corner_positions.any?{|pos| @game.board[pos] != nil}
      return @game.turn_num == 2 && opponent_chose_a_corner
    end 

    def corner_trap_position(opponent_marker)
      opponent_position = @game.board.find_index {|marker| marker == opponent_marker}
      safe_responses = {1=>[2,4], 3=>[2,6], 7=>[4,8], 9=>[6,8]}
      return safe_responses[opponent_position].sample
    end 

    def random_position
      ([5] + [1,3,7,9].shuffle + [2,4,6,8].shuffle).find do |pos|
        @game.free_positions.include?(pos)
      end
    end 
    
    def to_s 
      "Computer#{@game.current_player_id}"
    end 
  end 
end 

include TicTacToe

Game.new(ComputerPlayer, ComputerPlayer).play
puts
players_with_human = [HumanPlayer, ComputerPlayer].shuffle
Game.new(*players_with_human).play
