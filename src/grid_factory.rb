require './src/cell'
require './src/patterns'

class Grid

private
  attr_writer :alive, :cells, :dims, :depth, :pattern
public
  attr_reader :alive, :cells, :dims, :depth, :pattern

  def initialize(pattern, dims, alive = false, depth = 1)
    self.alive = alive
    self.pattern = pattern
    self.depth = depth
    self.cells = []
    self.dims = dims
  end

  def next(next_grid)
    self.each_cell_by_level do |c, i, j, level|
      next_cell = next_grid.cells[level][i][j]
      next_cell.set_alive(c.lives? neighbours(level, i, j))
    end

    next_grid
  end

  def each_cell_by_level
    return if !block_given?
    self.cells.each_with_index do |level_cells, level|
      level_cells.each_with_index do |row, i|
        row.each_with_index do |c, j|
          yield c, i, j, c.level
        end
      end
    end
  end

private
  def neighbours(level, i, j)
    level_cells = self.cells[level]
    rows = (i-1..i+1).map { |r| r % level_cells.length }
    cols = (j-1..j+1).map { |c| c % level_cells[0].length }

    rows.reduce([]) do |memo, r|
      cols.each { |c| memo.push level_cells[r][c] if !(r == i && c == j) }
      memo
    end
  end
end

class GridFactory
  def create_grid(opts = {})
    pattern = opts[:pattern] || []
    dims = opts[:dims] || [5, 5]
    depth = opts[:depth] || 1

    root = Grid.new(pattern, dims, true, depth)

    depth.times do |level|
      n_rows, n_cols = [0, 1].map { |i| dims[i]**(level+1) }

      current_level_cells = Array.new(n_rows) { Array.new(n_cols) { Cell.new(false, level) } }

      root.cells[level] = current_level_cells

      pattern.each_with_index do |row, i|
        row.each_with_index do |alive, j|
          grid_row = i
          while grid_row < current_level_cells.length
            grid_col = j
            while grid_col < current_level_cells[0].length
              current_level_cells[grid_row][grid_col].set_alive(alive == 1)
              grid_col += dims[1]
            end
            grid_row += dims[0]
          end
        end
      end

      current_level_cells.each_with_index do |row, i|
        row.each_with_index do |cell, j|
          next if level == 0
          cell.parent = root.cells[level-1][i/dims[0]][j/dims[1]]
        end
      end

    end

    root
  end

  def next_grid(grid)
    new_grid = self.create_grid(pattern: [], dims: grid.dims, depth: grid.depth)
    grid.next(new_grid)
  end
end
