require './spec/spec_helper'

RSpec.describe 'Grid' do
  require './src/grid_factory'

  describe '#next' do
    before(:each) do
      @grid = Grid.new([[0,0], [1,1]], [3,3])
      @grid.each_cell { |c| allow(c).to receive(:lives?).and_return(true) }

      @next_grid = Grid.new([], @grid.dims)
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
end
