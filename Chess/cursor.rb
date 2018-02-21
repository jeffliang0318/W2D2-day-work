require "io/console"
require_relative "board"
KEYMAP = {
  " " => :space,
  "h" => :left,
  "j" => :down,
  "k" => :up,
  "l" => :right,
  "w" => :up,
  "a" => :left,
  "s" => :down,
  "d" => :right,
  "\t" => :tab,
  "\r" => :return,
  "\n" => :newline,
  "\e" => :escape,
  "\e[A" => :up,
  "\e[B" => :down,
  "\e[C" => :right,
  "\e[D" => :left,
  "\177" => :backspace,
  "\004" => :delete,
  "\u0003" => :ctrl_c,
}

MOVES = {
  left: [0, -1],
  right: [0, 1],
  up: [-1, 0],
  down: [1, 0]
}

class Cursor

  attr_reader :cursor_pos, :board

  def initialize(cursor_pos, board)
    @cursor_pos = cursor_pos
    @board = board

  end

  def get_input(color, background)
    begin
      key = "placeholder"
      until key == :return || key == :newline
        system("clear")
        render_board(color, background)
        key = KEYMAP[read_char]
        handle_key(key)
        return @cursor_pos unless [:left, :right, :up, :down].include?(key)
      end
    rescue OutOfRangeError => e
      e.message
      sleep(1)
      retry
    end
  end

  def render_board(color, background)
    8.times do |i|
      8.times do |j|
        if [i,j] == @cursor_pos
          print @board[i][j].to_s.colorize(:color => color, :background => background) + "" if j < 7
          puts @board[i][j].to_s.colorize(:color => color, :background => background) if j == 7
        elsif j == 7
          if (i.odd?)
            puts @board[i][j].to_s.colorize(:color => :red, :background => :white)
          else
            puts @board[i][j].to_s
          end
        elsif i.odd?
          if j.odd?
            print (@board[i][j].to_s + "").colorize(:color => :red, :background => :white)
          else
            print (@board[i][j].to_s + "")
          end
        else
          if (i == 0 || i.even?) && (j == 0 || j.even?)
            print (@board[i][j].to_s + "").colorize(:color => :red, :background => :white)
          else
            print (@board[i][j].to_s + "")
          end
        end
      end
    end
  end
  private

  def read_char
    STDIN.echo = false # stops the console from printing return values

    STDIN.raw! # in raw mode data is given as is to the program--the system
                 # doesn't preprocess special characters such as control-c

    input = STDIN.getc.chr # STDIN.getc reads a one-character string as a
                             # numeric keycode. chr returns a string of the
                             # character represented by the keycode.
                             # (e.g. 65.chr => "A")

    if input == "\e" then
      input << STDIN.read_nonblock(3) rescue nil # read_nonblock(maxlen) reads
                                                   # at most maxlen bytes from a
                                                   # data stream; it's nonblocking,
                                                   # meaning the method executes
                                                   # asynchronously; it raises an
                                                   # error if no data is available,
                                                   # hence the need for rescue

      input << STDIN.read_nonblock(2) rescue nil
    end

    STDIN.echo = true # the console prints return values again
    STDIN.cooked! # the opposite of raw mode :)

    return input
  end

  def handle_key(key)
    case key
    when :left, :right, :up, :down
      new_pos = [@cursor_pos.first + MOVES[key].first , @cursor_pos.last + MOVES[key].last]
      raise OutOfRangeError unless new_pos.all? {|n| n.between?(0,7)}
      update_pos(new_pos)
    end
  end

  def update_pos(diff)
    @cursor_pos = diff
  end
end
