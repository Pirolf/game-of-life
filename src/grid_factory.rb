require './src/cell'
require './src/patterns'

class Grid

private
  attr_writer :alive, :cells, :dims, :depth, :pattern, :ancestor_alive
public
  attr_reader :alive, :cells, :dims, :depth, :pattern, :ancestor_alive

  def initialize(pattern, dims, alive = false, depth = 1)
    self.alive = alive
    self.pattern = pattern
    self.depth = depth
    self.cells = [[[Cell.new(alive, 0)]]]
    self.dims = dims
  end

  def next(next_grid)
    self.cells[1..-1].each_with_index do |level_cells, level_index|
      level = level_index + 1
      level_cells.each_with_index do |row, i|
        row.each_with_index do |cell, j|
          next_cell = next_grid.cells[level][i][j]
          next_cell.set_alive(cell.lives? neighbours(level, i, j))
        end
      end
    end

    next_grid
  end

  def each_cell
    return if !block_given?

    @cells.each_with_index do |row, i|
      row.each_with_index do |c, j|
        yield c, i, j
      end
    end
  end

  def each_cell_by_level
    return if !block_given?

    q = self.cells.flatten.map { |c| { grid: c, parent_alive: self.alive } }

    index_in_level = 0
    level = -1
    depth = self.depth

    while q.any?
      first = q.shift
      g = first[:grid]

      if g.depth != depth
        depth = g.depth
        index_in_level = 0
        level += 1
      end

      yield g, index_in_level, level, first[:parent_alive]

      if !g.cells.nil?
        g.each_cell { |c| q.push({ grid: c, parent_alive: g.alive }) }
      end

      index_in_level += 1
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

    (1..depth).each do |level|
      n_rows, n_cols = [0, 1].map { |i| dims[i]**level }

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
