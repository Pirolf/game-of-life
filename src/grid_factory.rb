require './src/cell'
require './src/organism'
require './src/patterns'

class Grid
  include Organism

private
  attr_writer :cells, :dims, :depth, :pattern
public
  attr_reader :cells, :dims, :depth, :pattern

  def initialize(pattern, dims, alive = false, depth = 1)
    super(alive)

    self.pattern = pattern
    self.depth = depth
    self.create_cells(pattern, dims, alive, depth)
  end

  def next(grid, depth = 1)
    return self if depth <= 0

    self.each_cell do |c, i, j|
      next_cell = grid.cells[i][j]
      next_cell.set_alive(c.lives? neighbours(i, j))

      next_cell = c.next(
        Grid.new([], c.dims, false, depth-1),
        depth-1
      )
    end

    grid
  end

  def each_cell
    return if !block_given?

    @cells.each_with_index do |row, i|
      row.each_with_index do |c, j|
        yield c, i, j
      end
    end
  end

  def all_cells(r_offset = 0, c_offset = 0, &block)
    self.each_cell do |c, i, j|
      if c.cells.nil?
        yield c, i + r_offset, j + c_offset
      else
        c.all_cells(i * self.dims[0], j * self.dims[1], &block)
      end
    end
  end

protected
  def create_cells(pattern, dims, alive, depth)
    return if depth <= 0
    cells = Array.new(dims[0]) { Array.new(dims[1]) { Grid.new(pattern, dims, false, depth-1) } }
    
    pattern.each_with_index do |row, i|
      row.each_with_index do |child_alive, j|
        cells[i][j].set_alive(child_alive == 1)
      end
    end

    self.cells = cells
    self.dims = dims
  end

private
  def neighbours(i, j)
    rows = (i-1..i+1).map { |r| r % @cells.length }
    cols = (j-1..j+1).map { |c| c % @cells[0].length }

    rows.reduce([]) do |memo, r|
      cols.each { |c| memo.push @cells[r][c] if !(r == i && c == j) }
      memo
    end
  end
end

class GridFactory
  def create_grid(opts = {})
    pattern = opts[:pattern] || Patterns::BLINKER
    dims = opts[:dims] || [5, 5]
    depth = opts[:depth] || 1

    Grid.new(pattern, dims, false, depth)
  end

  def next_grid(grid)
    new_grid = self.create_grid(pattern: grid.pattern, dims: grid.dims, depth: grid.depth)
    grid.next(new_grid, new_grid.depth)
  end
end
