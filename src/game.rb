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
    self.grid_map = Array.new

    self.max_level.times do |i|
      self.grid_map.push Chingu::GameObjectList.new
    end
  end

  def setup
    super

    self.grid_factory = GridFactory.new
    dims = [5, 5]
    @grid = self.grid_factory.create_grid(pattern: Patterns::GLIDER, dims: dims, depth: self.max_level)

    @grid.cells[1..-1].each_with_index do |level_cells, level|
      level_index = level + 1
      cell_width = 640/dims[0]**level_index

      level_cells.each_with_index do |row, i|
        row.each_with_index do |c, j|
          g = GridCell.create grid: c, x: (j + 0.5)*cell_width, y: (i + 0.5)*cell_width, zorder: i, scale: cell_width/CELL_SIZE.to_f

          self.grid_map[level].add_game_object g
        end
      end
    end

    every(1000) { next_generation }
  end

  def draw
    draw_map = []
    @grid.cells[1..-1].each_with_index do |level_cells, level|
      if level > draw_map.length - 1
        draw_map.push []
      end

      level_cells.each_with_index do |row, i|
        row.each_with_index do |c, j|
          draw_map[level].push(c.ancestor_alive? && c.alive)
        end
      end
    end

    self.grid_map.each_with_index do |level_cells, level|
      level_cells.each_with_index do |c, i|
        if draw_map[level][i]
          c.draw
        end
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
    self.color = colors[self.grid.level-1]
  end
end

Game.new.show
