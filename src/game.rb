require 'chingu'
require './src/grid_factory'
require './src/patterns'

class Game < Chingu::Window
  def initialize
    super(640,640,false)
    push_game_state(GameOfLife)
  end
end

class GameOfLife < Chingu::GameState
  traits :timer

  CELL_SIZE = 23

private
  attr_writer :grid, :grid_factory, :grid_map, :game_width, :game_height, :max_level
public
  attr_reader :grid, :grid_factory, :grid_map, :game_width, :game_height, :max_level

  def initialize
    super

    self.game_width = 640
    self.game_height = 640
    self.max_level = 3
    self.grid_factory = GridFactory.new
    self.grid_map = Array.new(self.max_level) { Chingu::GameObjectList.new }
  end

  def setup
    super

    dims = [5, 5]
    @grid = self.grid_factory.create_grid(pattern: Patterns::GLIDER, dims: dims, depth: self.max_level)

    @grid.each_cell_by_level do |c, i, j, level|
      cell_width = 640/dims[0]**(level+1)
      g = GridCell.create grid: c, x: (j + 0.5)*cell_width, y: (i + 0.5)*cell_width, zorder: i, scale: cell_width/CELL_SIZE.to_f

      self.grid_map[level].add_game_object g
    end

    every(1000) { next_generation }
  end

  def draw
    draw_map = Array.new(@grid.depth) { [] }
    @grid.each_cell_by_level do |c, i, j, level|
      draw_map[level].push(c.ancestor_alive? && c.alive)
    end

    self.grid_map.each_with_index do |level_cells, level|
      level_cells.each_with_index do |c, i|
        c.draw if draw_map[level][i]
      end
    end
  end

private
  def next_generation
    @grid = @grid_factory.next_grid(@grid)
  end
end

class GridCell < Chingu::GameObject
  attr_accessor :grid

  def setup
    super
    colors = [0xff00aaff, 0xff5500ff, 0xff0000ff]
    self.image = "white_poop.png"
    self.grid = options[:grid]
    self.color = colors[self.grid.level]
  end
end

Game.new.show
