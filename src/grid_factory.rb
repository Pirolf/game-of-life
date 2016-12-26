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
     self.cells.each_with_index do |row, i|
       row.each_with_index do |c, j|
         grid.cells[i][j].set_alive(c.lives? neighbours(i, j))
       end
     end

     return grid
   end

private
   def neighbours(i, j)
     rows = (i-1..i+1).select { |r| r >= 0 && r < @cells.length }
     cols = (j-1..j+1).select { |c| c >= 0 && c < @cells[0].length }

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
