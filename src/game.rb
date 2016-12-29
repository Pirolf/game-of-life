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
  attr_accessor :grid, :grid_factory, :grid_map, :game_width, :game_height, :max_level

public
  def initialize
    super

    self.game_width = 640
    self.game_height = 480
    self.max_level = 3
    self.grid_map = {}
    self.grid_factory = GridFactory.new
    self.grid = self.grid_factory.create_grid(pattern: Patterns::GLIDER, dims: [8, 8])

    every(200) { next_generation }
  end

  def setup
    super
    self.max_level.times { |i| self.grid_map[i] = Chingu::GameObjectList.new }
  end

  def draw
    super
    @grid_map.each do |grids|
      grids.draw
    end
  end

private
  def next_generation
    @grid = @grid_factory.next_grid(@grid, self.max_level)
    root_dims = @grid.dims

    @grid.each_cell_by_level do |c, i, j|
      # cell_width, cell_height = [
      #   {game_d: game_width, root_d: root_dims[0]},
      #   {game_d: game_height, root_d: root_dims[1]},
      # ].map do |dims_data|
      #   dims_data[:game_d]/(dims_data[:root_d]**(self.max_level - c.depth))
      # end
      cell_width = 128
      cell_height = 128
      grid_cell = GridCell.create grid: c, x: (i + 0.5)*cell_width, y: (j + 0.5)*cell_height

      @grid_map[c.depth].add_game_object grid_cell
      # key = "r#{i}c#{j}".to_sym
      # if c.alive && !@grid_cells.has_key?(key)
      #   @grid_cells[key] = GridCell.create(x: (i + 0.5)*CELL_SIZE, y: (j + 0.5)*CELL_SIZE)
      # end
      #
      # if !c.alive && @grid_cells.has_key?(key)
      #   @grid_cells[key].destroy
      #   @grid_cells.delete key
      # end
    end
  end
end

class GridCell < Chingu::GameObject
  trait :sprite
  attr_accessor :should_draw, :grid

  def setup
    super
    self.image = "poop.png"
    self.should_draw = false
  end

  def draw
    return if !self.should_draw

    Gosu::translate(x, y) do
      Gosu::scale(scaler) do
        super
      end
    end
  end
end

Game.new.show
