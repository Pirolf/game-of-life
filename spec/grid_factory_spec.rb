require './spec/spec_helper'

RSpec.describe 'GridFactory' do
  require './src/grid_factory'
  require './src/cell'

  let(:factory) { @factory = GridFactory.new }

  describe '#create_grid' do
    it 'creates a grid with default cells' do
      grid = factory.create_grid(dims: [3, 4])
      expect(grid.cells.length).to be(3)
      expect(grid.cells[0].length).to be(4)

      grid.cells.each_with_index do |row, i|
        row.each_with_index do |cell, j|
          alive = (i == 0 && j == 0 || i == 0 && j == 1 || i == 1 && j == 0)
          expect(cell.alive).to be(alive)
        end
      end
    end

    it 'creates a grid with default dimensions' do
      grid = factory.create_grid(pattern: [[0, 0], [1, 1]])

      expect(grid.cells.length).to be(5)
      expect(grid.cells[0].length).to be(5)

      grid.cells.each_with_index do |row, i|
        row.each_with_index do |cell, j|
          alive = (i == 0 && j == 0 || i == 1 && j == 1)
          expect(cell.alive).to be(alive)
        end
      end
    end

    it 'creates a grid with custom cells and dimensions' do
      grid = factory.create_grid(pattern: [[0, 0], [1, 1]], dims: [3, 4])

      expect(grid.cells.length).to be(3)
      expect(grid.cells[0].length).to be(4)

      grid.cells.each_with_index do |row, i|
        row.each_with_index do |cell, j|
          alive = (i == 0 && j == 0 || i == 1 && j == 1)
          expect(cell.alive).to be(alive)
        end
      end
    end
  end

  describe '#next_grid' do
    def mock_lives(cells)
      cells.each_with_index do |row, i|
        row.each_with_index do |c, j|
          allow(c).to receive(:lives?).and_return(i == j)
        end
      end
    end

    it 'returns the next grid' do
      grid = factory.create_grid(pattern: [[0, 0], [1, 1]])
      mock_lives(grid.cells)

      next_grid = @factory.next_grid(grid)

      expect { grid }.not_to change(grid, :cells)

      next_grid.cells.each_with_index do |row, i|
        row.each_with_index do |cell, j|
          expect(cell.alive).to be(i == j)
        end
      end
    end
  end
end
