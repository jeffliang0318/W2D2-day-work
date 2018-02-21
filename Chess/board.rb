require_relative 'piece'
require_relative 'sliding_piece'
require_relative 'null_piece'
require_relative 'pawns'
require_relative 'stepping_piece'
require_relative 'display'

class Board

  attr_reader :chess_board, :display

  def initialize
    @chess_board = Array.new(8){Array.new(8)}
    @starting_board = [:xxROOKx,
                        :xKNIGHT,
                        :BISHOPx,
                        :xQUEENx,
                        :xxKINGx,
                        :xBISHOP,
                        :xKNIGHT,
                        :xxROOKx]
    generate_new_board
    create_instances
    @display = Display.new(self.chess_board)
    system("clear")
  end

  def generate_new_board
    8.times do |idx1|
      if idx1 == 1 || idx1 == 6
        8.times do |i|
          @chess_board[idx1][i] = :xxPAWNx
        end
      elsif idx1 == 0 || idx1 == 7
        @chess_board[idx1] = @starting_board.dup
      else
        8.times do |i|
          @chess_board[idx1][i] = "(˘ ³˘)♥"
        end
      end
    end
  end

  def create_instances
    8.times do |i|
      8.times do |j|
          case @chess_board[i][j]
          when :rook, :bishop, :queen
            puts "Creating new slide piece"
            SlidingPiece.new
          when :knight, :king
            puts "Creating new stepping piece"
            SteppingPiece.new
          when :pawn
            puts "Creating new pawn"
            Pawns.new
          end
      end

    end
  end

  def [](*pos)
    x, y = pos
    @chess_board[x][y]
  end

  def []=(*pos, value)
    x, y = pos
    @chess_board[x][y] = value
  end

  def move_piece(start_pos, end_pos)
    starting_x, starting_y = start_pos
    ending_x, ending_y = end_pos
    self[ending_x, ending_y] = self[starting_x, starting_y]
    self[starting_x, starting_y] = "(˘ ³˘)♥"
  end


  def valid_play?(start_pos, end_pos)
    starting_x, starting_y = start_pos
    ending_x, ending_y = end_pos
    begin
      # raise OutOfRangeError unless (start_pos + end_pos).all?{|el| el.between?(0,7)}
      raise NoPieceError if self[starting_x, starting_y] == "(˘ ³˘)♥"
      raise SamePositionError if start_pos == end_pos
    rescue => e
      puts e.message
      sleep(1)
      return false
    end
    true
  end

  def prompt_user
    start_pos, end_pos = @display.render
    prompt_user unless valid_play?(start_pos, end_pos)
    move_piece(start_pos, end_pos)
  end

  def game_over
    counter = 0
    loop do
      dance1(counter)
      counter += 1
      dance2(counter)
      counter += 1
      counter = 0 if counter == 30
    end
  end

  def dance1(count)
    system("clear")
    str = ""
    count.times {str += " "}
    puts "#{str}DANCE PARTY~~ \\(ఠ v ఠ ) ( ఠ v ఠ)/ ~~DANCE PARTY"
    puts "#{str}DANCE PARTY~~     |\\       /|     ~~DANCE PARTY"
    puts "#{str}DANCE PARTY~~    / \\       / \\    ~~DANCE PARTY"
    sleep(0.5)
  end

  def dance2(count)
    system("clear")
    str = ""
    count.times {str += " "}
    puts "#{str}DANCE PARTY~~ ( ఠ v ఠ)/ \\(ఠ v ఠ )/ ~~DANCE PARTY"
    puts "#{str}DANCE PARTY~~     |\\       /|     ~~DANCE PARTY"
    puts "#{str}DANCE PARTY~~    / \\       / \\    ~~DANCE PARTY"
    sleep(0.5)
  end
end

class SamePositionError < StandardError
  def message
    puts "End pos can not be same as start pos"
  end
end

class OutOfRangeError < StandardError
  def message
    puts "Out of range position!"
  end
end

class NoPieceError < StandardError
  def message
    puts "No piece here!"
  end
end
