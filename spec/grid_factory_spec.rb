require './spec/spec_helper'

RSpec.describe 'GridFactory' do
  require './src/grid_factory'
  require './src/cell'

  let(:factory) { @factory = GridFactory.new }

  describe '#create_grid' do
    it 'creates a grid with default all dead cells' do
      grid = factory.create_grid(dims: [3, 4])
      expect(grid.cells.length).to be(1)

      expect(grid.cells[0].length).to be(3)
      expect(grid.cells[0][0].length).to be(4)

      expect(grid.alive).to be(true)
      grid.cells[0].each_with_index do |row, i|
        row.each_with_index do |cell, j|
          expect(cell.alive).to be(false)
        end
      end
    end

    it 'creates single level grid' do
      grid = factory.create_grid(pattern: [
        [0, 1],
        [1, 1]
      ], dims: [3, 4])

      expect(grid.cells.length).to be(1)

      expect(grid.cells[0].length).to be(3)
      expect(grid.cells[0][0].length).to be(4)

      grid.cells[0].each_with_index do |row, i|
        row.each_with_index do |cell, j|
          alive = (i == 0 && j == 1 || i == 1 && j < 2)
          expect(cell.alive).to be(alive)
        end
      end
    end

    it 'creates a nested grid' do
      grid = factory.create_grid(pattern: [
        [0, 1]
      ], dims: [1, 2], depth: 2)

      expect(grid.cells.count).to be(2)

      expect(grid.cells[0].length).to be(1)
      expect(grid.cells[0][0].length).to be(2)
      expect(grid.cells[0][0][0].alive).to be(false)
      expect(grid.cells[0][0][1].alive).to be(true)

      expect(grid.cells[0][0][0].parent).to be_nil
      expect(grid.cells[0][0][1].parent).to be_nil

      expect(grid.cells[0][0][0].level).to be(0)
      expect(grid.cells[0][0][1].level).to be(0)

      expect(grid.cells[1][0].length).to be(4)
      expect(grid.cells[1][0][0].alive).to be(false)
      expect(grid.cells[1][0][1].alive).to be(true)
      expect(grid.cells[1][0][2].alive).to be(false)
      expect(grid.cells[1][0][3].alive).to be(true)

      expect(grid.cells[1][0][0].parent).to eq(grid.cells[0][0][0])
      expect(grid.cells[1][0][1].parent).to eq(grid.cells[0][0][0])
      expect(grid.cells[1][0][2].parent).to eq(grid.cells[0][0][1])
      expect(grid.cells[1][0][3].parent).to eq(grid.cells[0][0][1])

      (0..1).each do |level|
        grid.cells[level][0].each do |c|
          expect(c.level).to be(level)
        end
      end
    end
  end

  describe '#next_grid' do
    def mock_lives(grid)
      grid.cells.each do |cells|
        cells.each_with_index do |row, i|
          row.each_with_index do |c, j|
            allow(c).to receive(:lives?).and_return(i == j)
            allow(c).to receive(:next).and_return(c)
          end
        end
      end
    end

    it 'returns the next grid' do
      grid = factory.create_grid(pattern: [
        [0, 1],
        [1, 1]
      ])
      mock_lives(grid)

      next_grid = @factory.next_grid(grid)

      expect { grid }.not_to change(grid, :cells)

      next_grid.cells.each do |cells|
        cells.each_with_index do |row, i|
          row.each_with_index do |c, j|
            expect(c.alive).to be(i == j)
          end
        end
      end

    end
  end
end
