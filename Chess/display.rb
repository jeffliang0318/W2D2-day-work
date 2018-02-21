require 'colorize'
require 'rainbow'
require_relative 'board'
require_relative 'cursor'

class Display
  def initialize(board)
   @cursor = Cursor.new([0,0], board)
  end

  def render
    start_pos = @cursor.get_input(:blue, :light_green)
    end_pos = @cursor.get_input(:red, :light_blue)
    [start_pos, end_pos]
  end
end
