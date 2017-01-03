require './spec/spec_helper'

RSpec.describe 'Grid' do
  require './src/grid_factory'

  let(:factory) { @factory = GridFactory.new }
  describe '#next' do
    before(:each) do
      @grid = factory.create_grid(pattern: [[0,0], [1,1]], dims: [3,3])
      @grid.cells.each do |level_cells|
        level_cells.each do |row|
          row.each do |c|
            allow(c).to receive(:lives?).and_return(true)
          end
        end
      end

      @next_grid = @factory.create_grid(pattern: [], dims: @grid.dims)
    end

    it 'calls live? on every cell' do
      @grid.next(@next_grid)
      cells = @grid.cells

      level1_cells = cells[0]

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
      @grid = factory.create_grid(pattern: [[1,1], [1,1]], dims: [2, 2], depth: 2)
    end

    it 'yeilds by level' do
      level_cells = (0..1).reduce([]) do |cells, level|
        args = (0..2**(level+1)-1).reduce([]) do |memo, i|
          (2**(level+1)).times do |j|
            memo.push [@grid.cells[level][i][j], i, j, level]
          end
          memo
        end

        cells.push(*args)
      end

      expect{ |b| @grid.each_cell_by_level(&b) }.to yield_successive_args(*level_cells)
    end
  end
end
