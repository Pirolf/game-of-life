require './spec/spec_helper'

RSpec.describe 'GridFactory' do
  require './src/grid_factory'
  require './src/cell'
  require './src/patterns'

  let(:factory) { @factory = GridFactory.new }

  describe '#create_grid' do
    it 'creates a grid with default cells' do
      grid = factory.create_grid(dims: [3, 4])
      expect(grid.cells.length).to be(3)
      expect(grid.cells[0].length).to be(4)

      grid.each_cell do |c, i, j|
        alive = (i == 0 && j < 3)
        expect(c.alive).to be(alive)
      end
    end

    it 'creates a grid with default dimensions' do
      grid = factory.create_grid(pattern: [[0, 1]])

      expect(grid.cells.length).to be(5)
      expect(grid.cells[0].length).to be(5)

      grid.each_cell do |c, i, j|
        alive = (i == 0 && j == 1)
        expect(c.alive).to be(alive)
      end
    end

    it 'creates a grid with custom cells and dimensions' do
      grid = factory.create_grid(pattern: [
        [0, 1],
        [1, 1]
      ], dims: [3, 4])

      expect(grid.cells.length).to be(3)
      expect(grid.cells[0].length).to be(4)

      grid.each_cell do |c, i, j|
        alive = (i == 0 && j == 1 || i == 1 && j < 2)
        expect(c.alive).to be(alive)
      end
    end

    it 'creates a nested grid' do
      grid = factory.create_grid(pattern: [
        [0, 1]
      ], dims: [1, 2], depth: 2)

      expect(grid.depth).to be(2)

      expect(grid.cells.length).to be(1)
      expect(grid.cells[0].length).to be(2)

      expect(grid.cells[0][0].alive).to be(false)
      expect(grid.cells[0][1].alive).to be(true)

      expect(grid.cells[0][0].depth).to be(1)
      expect(grid.cells[0][1].depth).to be(1)

      [0,1].map { |j| grid.cells[0][j] }.each do |c|
        expect(c.cells.length).to be(1)
        expect(c.cells[0].length).to be(2)

        expect(c.cells[0][0].alive).to be(false)
        expect(c.cells[0][1].alive).to be(true)

        expect(c.cells[0][0].cells).to be_nil
        expect(c.cells[0][1].cells).to be_nil
      end
    end
  end

  describe '#next_grid' do
    def mock_lives(grid)
      grid.each_cell do |c, i, j|
        allow(c).to receive(:lives?).and_return(i == j)
        allow(c).to receive(:next).and_return(c)
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
      next_grid.each_cell { |c, i, j| expect(c.alive).to be(i == j) }
    end
  end
end
