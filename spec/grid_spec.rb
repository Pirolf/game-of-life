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
      @grid = Grid.new([[0,0], [1,1]], [3,3])
      @grid.each_cell do |c|
        allow(c).to receive(:lives?).and_return(true)
      end

      @next_grid = Grid.new([], @grid.dims)
    end

    context 'grid is nested' do
      before(:each) { @grid.each_cell { |c| allow(c).to receive(:next).and_return(c) } }

      it 'recursively calls next on the cells' do
        @grid.next(@next_grid, 1)
        @grid.each_cell do |c|
          expect(c).to have_received(:next)
        end
      end
    end

    it 'calls live? on every cell' do
      @grid.next(@next_grid)
      cells = @grid.cells

      expect(cells[0][0]).to have_received(:lives?).with([
        cells[2][2], cells[2][0], cells[2][1],
        cells[0][2], cells[0][1],
        cells[1][2], cells[1][0], cells[1][1]
      ])
      expect(cells[0][1]).to have_received(:lives?).with([
        cells[2][0], cells[2][1], cells[2][2],
        cells[0][0], cells[0][2],
        cells[1][0], cells[1][1], cells[1][2]
      ])
      expect(cells[0][2]).to have_received(:lives?).with([
        cells[2][1], cells[2][2], cells[2][0],
        cells[0][1], cells[0][0],
        cells[1][1], cells[1][2], cells[1][0]
      ])
      expect(cells[1][0]).to have_received(:lives?).with([
        cells[0][2], cells[0][0], cells[0][1],
        cells[1][2], cells[1][1],
        cells[2][2], cells[2][0], cells[2][1]
      ])
      expect(cells[1][1]).to have_received(:lives?).with([
        cells[0][0], cells[0][1], cells[0][2],
        cells[1][0], cells[1][2],
        cells[2][0], cells[2][1], cells[2][2]
      ])
      expect(cells[1][2]).to have_received(:lives?).with([
        cells[0][1], cells[0][2], cells[0][0],
        cells[1][1], cells[1][0],
        cells[2][1], cells[2][2], cells[2][0]
      ])
      expect(cells[2][0]).to have_received(:lives?).with([
        cells[1][2], cells[1][0], cells[1][1],
        cells[2][2], cells[2][1],
        cells[0][2], cells[0][0], cells[0][1],
      ])
      expect(cells[2][1]).to have_received(:lives?).with([
        cells[1][0], cells[1][1], cells[1][2],
        cells[2][0], cells[2][2],
        cells[0][0], cells[0][1], cells[0][2],
      ])
      expect(cells[2][2]).to have_received(:lives?).with([
        cells[1][1], cells[1][2], cells[1][0],
        cells[2][1], cells[2][0],
        cells[0][1], cells[0][2], cells[0][0]
      ])
    end
  end

  describe '#all_cells' do
    before(:each) do
      @grid = Grid.new([
        [0,1]
      ], [3,2], false, 2)
    end

    it 'yields for all cell descendents' do
      expect{ |b| @grid.all_cells(&b) }.to yield_successive_args(
        [@grid.cells[0][0].cells[0][0], 0, 0],
        [@grid.cells[0][0].cells[0][1], 0, 1],
        [@grid.cells[0][0].cells[1][0], 1, 0],
        [@grid.cells[0][0].cells[1][1], 1, 1],
        [@grid.cells[0][0].cells[2][0], 2, 0],
        [@grid.cells[0][0].cells[2][1], 2, 1],

        [@grid.cells[0][1].cells[0][0], 0, 2],
        [@grid.cells[0][1].cells[0][1], 0, 3],
        [@grid.cells[0][1].cells[1][0], 1, 2],
        [@grid.cells[0][1].cells[1][1], 1, 3],
        [@grid.cells[0][1].cells[2][0], 2, 2],
        [@grid.cells[0][1].cells[2][1], 2, 3],

        [@grid.cells[1][0].cells[0][0], 3, 0],
        [@grid.cells[1][0].cells[0][1], 3, 1],
        [@grid.cells[1][0].cells[1][0], 4, 0],
        [@grid.cells[1][0].cells[1][1], 4, 1],
        [@grid.cells[1][0].cells[2][0], 5, 0],
        [@grid.cells[1][0].cells[2][1], 5, 1],

        [@grid.cells[1][1].cells[0][0], 3, 2],
        [@grid.cells[1][1].cells[0][1], 3, 3],
        [@grid.cells[1][1].cells[1][0], 4, 2],
        [@grid.cells[1][1].cells[1][1], 4, 3],
        [@grid.cells[1][1].cells[2][0], 5, 2],
        [@grid.cells[1][1].cells[2][1], 5, 3],

        [@grid.cells[2][0].cells[0][0], 6, 0],
        [@grid.cells[2][0].cells[0][1], 6, 1],
        [@grid.cells[2][0].cells[1][0], 7, 0],
        [@grid.cells[2][0].cells[1][1], 7, 1],
        [@grid.cells[2][0].cells[2][0], 8, 0],
        [@grid.cells[2][0].cells[2][1], 8, 1],

        [@grid.cells[2][1].cells[0][0], 6, 2],
        [@grid.cells[2][1].cells[0][1], 6, 3],
        [@grid.cells[2][1].cells[1][0], 7, 2],
        [@grid.cells[2][1].cells[1][1], 7, 3],
        [@grid.cells[2][1].cells[2][0], 8, 2],
        [@grid.cells[2][1].cells[2][1], 8, 3],
      )
    end
  end
end
