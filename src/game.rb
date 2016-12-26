require 'chingu'
require './src/grid_factory'
# also look at https://github.com/ippa/chingu/blob/master/examples/game_of_life.rb

class Game < Chingu::Window
  def initialize(pattern = nil)
    super(640,480,false)
    push_game_state(GameOfLife)
  end

  def draw
    fill_rect([0,0,640,480], 0xffffffff, -2)
    super
  end
end

class GameOfLife < Chingu::GameState
  traits :timer
  CELL_SIZE = 10

private
  attr_accessor :grid, :grid_factory, :start_time

public
  def initialize
    super
    @start_time = Time.now.to_f
    @grid_factory = GridFactory.new
    @grid = @grid_factory.create_grid(pattern: [[1, 2], [2, 2], [3, 2]], dims: [5, 5])
    every(1000) { @grid = @grid_factory.next_grid(@grid) }
  end

  def draw
    @grid.cells.each_with_index do |row, i|
      row.each_with_index do |c, j|
        if c.alive
          $window.fill_rect([i*CELL_SIZE,j*CELL_SIZE,CELL_SIZE,CELL_SIZE],0xff000000,0)
        end
      end
    end
  end
end

Game.new.show
