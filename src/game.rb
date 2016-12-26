require 'chingu'
require './src/grid_factory'
require './src/patterns'

class Game < Chingu::Window
  def initialize
    super(640,480,false)
    push_game_state(GameOfLife)
  end
end

class GameOfLife < Chingu::GameState
  traits :timer
  CELL_SIZE = 23

private
  attr_accessor :grid, :grid_factory, :grid_cells

public
  def initialize
    super

    @grid_cells = {}
    @grid_factory = GridFactory.new
    @grid = @grid_factory.create_grid(pattern: Patterns::GLIDER, dims: [640/23, 480/23])

    every(200) { next_generation }
  end

private
  def next_generation
    @grid = @grid_factory.next_grid(@grid)

    @grid.each_cell do |c, i, j|
      key = "r#{i}c#{j}".to_sym
      if c.alive && !@grid_cells.has_key?(key)
        @grid_cells[key] = GridCell.create(x: (i + 0.5)*CELL_SIZE, y: (j + 0.5)*CELL_SIZE)
      end

      if !c.alive && @grid_cells.has_key?(key)
        @grid_cells[key].destroy
        @grid_cells.delete key
      end
    end
  end
end

class GridCell < Chingu::GameObject
  trait :sprite

  def setup
    super
    self.image = "poop.png"
  end
end

Game.new.show
