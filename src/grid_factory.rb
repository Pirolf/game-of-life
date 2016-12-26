require './src/cell'
require './src/patterns'

class Grid
private
  attr_writer :cells, :dims
public
  attr_reader :cells, :dims

  def initialize(pattern, dims)
    cells = Array.new(dims[0]) { Array.new(dims[1]) { Cell.new } }
    pattern.each_with_index do |row, i|
      row.each_with_index do |alive, j|
        cells[i][j].set_alive(alive == 1)
      end
    end

    self.cells = cells
    self.dims = dims
   end

   def next(grid)
     self.each_cell { |c, i, j| grid.cells[i][j].set_alive(c.lives? neighbours(i, j)) }
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

    Grid.new(pattern, opts[:dims] || [5, 5])
  end

  def next_grid(grid)
    new_grid = self.create_grid(dims: grid.dims)
    grid.next(new_grid)
  end
end
