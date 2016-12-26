require 'chingu'
require './src/grid_factory'
require './src/cell'

class Game < Chingu::Window
  def initialize(pattern = nil)
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
    @grid = @grid_factory.create_grid(pattern: [[1, 2], [2, 2], [3, 2]], dims: [5, 5])

    every(1000) do
      @grid = @grid_factory.next_grid(@grid)

      @grid.cells.each_with_index do |row, i|
        row.each_with_index do |c, j|
          key = "r#{i}c#{j}".to_sym
          if c.alive
            @grid_cells[key] ||= GridCell.create(x: (i + 0.5)*CELL_SIZE, y: (j + 0.5)*CELL_SIZE)
            @grid_cells[key].show!
          else
            @grid_cells[key].hide! if @grid_cells.has_key? key
          end
        end
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
