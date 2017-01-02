require './spec/spec_helper'

RSpec.describe 'Grid' do
  require './src/grid_factory'

  describe '#initialize' do
    it 'generates nested grids' do
      @grid = Grid.new([
        [1,0],
        [0,1]
      ], [2, 2], false, 2)
      expect(@grid.cells.length).to be(2)
      expect(@grid.cells[0].length).to be(2)

      @grid.each_cell do |g, i, j|
        expect(g).to be_an_instance_of(Grid)
        expect(g.alive).to be(i == j)

        g.each_cell do |c, m, n|
          expect(c.alive).to be(m == n)
        end
      end
    end
  end

  describe '#next' do
    before(:each) do
      factory = GridFactory.new
      @grid = factory.create_grid(pattern: [[0,0], [1,1]], dims: [3,3])
      @grid.cells.each do |level_cells|
        level_cells.each do |row|
          row.each do |c|
            allow(c).to receive(:lives?).and_return(true)
          end
        end
      end

      @next_grid = factory.create_grid(pattern: [], dims: @grid.dims)
    end

    it 'calls live? on every cell' do
      @grid.next(@next_grid)
      cells = @grid.cells

      expect(cells[0][0][0]).not_to have_received(:lives?)

      level1_cells = cells[1]

      expect(level1_cells[0][0]).to have_received(:lives?).with([
        level1_cells[2][2], level1_cells[2][0], level1_cells[2][1],
        level1_cells[0][2], level1_cells[0][1],
        level1_cells[1][2], level1_cells[1][0], level1_cells[1][1]
      ])
      expect(level1_cells[0][1]).to have_received(:lives?).with([
        level1_cells[2][0], level1_cells[2][1], level1_cells[2][2],
        level1_cells[0][0], level1_cells[0][2],
        level1_cells[1][0], level1_cells[1][1], level1_cells[1][2]
      ])
      expect(level1_cells[0][2]).to have_received(:lives?).with([
        level1_cells[2][1], level1_cells[2][2], level1_cells[2][0],
        level1_cells[0][1], level1_cells[0][0],
        level1_cells[1][1], level1_cells[1][2], level1_cells[1][0]
      ])
      expect(level1_cells[1][0]).to have_received(:lives?).with([
        level1_cells[0][2], level1_cells[0][0], level1_cells[0][1],
        level1_cells[1][2], level1_cells[1][1],
        level1_cells[2][2], level1_cells[2][0], level1_cells[2][1]
      ])
      expect(level1_cells[1][1]).to have_received(:lives?).with([
        level1_cells[0][0], level1_cells[0][1], level1_cells[0][2],
        level1_cells[1][0], level1_cells[1][2],
        level1_cells[2][0], level1_cells[2][1], level1_cells[2][2]
      ])
      expect(level1_cells[1][2]).to have_received(:lives?).with([
        level1_cells[0][1], level1_cells[0][2], level1_cells[0][0],
        level1_cells[1][1], level1_cells[1][0],
        level1_cells[2][1], level1_cells[2][2], level1_cells[2][0]
      ])
      expect(level1_cells[2][0]).to have_received(:lives?).with([
        level1_cells[1][2], level1_cells[1][0], level1_cells[1][1],
        level1_cells[2][2], level1_cells[2][1],
        level1_cells[0][2], level1_cells[0][0], level1_cells[0][1],
      ])
      expect(level1_cells[2][1]).to have_received(:lives?).with([
        level1_cells[1][0], level1_cells[1][1], level1_cells[1][2],
        level1_cells[2][0], level1_cells[2][2],
        level1_cells[0][0], level1_cells[0][1], level1_cells[0][2],
      ])
      expect(level1_cells[2][2]).to have_received(:lives?).with([
        level1_cells[1][1], level1_cells[1][2], level1_cells[1][0],
        level1_cells[2][1], level1_cells[2][0],
        level1_cells[0][1], level1_cells[0][2], level1_cells[0][0]
      ])
    end
  end

  describe '#each_cell_by_level' do
    before(:each) do
      @grid = Grid.new([[1,1], [1,1]], [2, 2], true, 2)
      @grid.cells[0][1].set_alive false
      @grid.cells[1][0].set_alive false
    end

    it 'yeilds by level' do
      expect{ |b| @grid.each_cell_by_level(&b) }.to yield_successive_args(
        [@grid.cells[0][0], 0, 0, true],
        [@grid.cells[0][1], 1, 0, true],
        [@grid.cells[1][0], 2, 0, true],
        [@grid.cells[1][1], 3, 0, true],

        [@grid.cells[0][0].cells[0][0], 0, 1, true],
        [@grid.cells[0][0].cells[0][1], 1, 1, true],
        [@grid.cells[0][0].cells[1][0], 2, 1, true],
        [@grid.cells[0][0].cells[1][1], 3, 1, true],

        [@grid.cells[0][1].cells[0][0], 4, 1, false],
        [@grid.cells[0][1].cells[0][1], 5, 1, false],
        [@grid.cells[0][1].cells[1][0], 6, 1, false],
        [@grid.cells[0][1].cells[1][1], 7, 1, false],

        [@grid.cells[1][0].cells[0][0], 8, 1, false],
        [@grid.cells[1][0].cells[0][1], 9, 1, false],
        [@grid.cells[1][0].cells[1][0], 10, 1, false],
        [@grid.cells[1][0].cells[1][1], 11, 1, false],

        [@grid.cells[1][1].cells[0][0], 12, 1, true],
        [@grid.cells[1][1].cells[0][1], 13, 1, true],
        [@grid.cells[1][1].cells[1][0], 14, 1, true],
        [@grid.cells[1][1].cells[1][1], 15, 1, true]
      )
    end
  end
end
