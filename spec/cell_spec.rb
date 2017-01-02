require './spec/spec_helper'

RSpec.describe 'Cell' do
  require './src/cell'

  let(:cell) { @cell = Cell.new(true, 0) }

  describe '#lives?' do
    let(:live) { instance_double('Cell', alive: true) }
    let(:dead) { instance_double('Cell', alive: false) }

    context 'cell is alive' do
      before(:each) { cell.set_alive(true) }
      context 'with fewer than 2 live neighbour cells' do
        it 'dies' do
          neighbours = [live, dead, dead]
          expect(@cell.lives? neighbours).to be(false)
        end
      end

      context 'with 2 or 3 live neighbour cells' do
        it 'lives' do
          neighbours = [live, dead, live]
          expect(@cell.lives? neighbours).to be(true)

          neighbours = [live, dead, live, live]
          expect(@cell.lives? neighbours).to be(true)
        end
      end

      context 'with more than 3 live neighbour cells' do
        it 'dies' do
          neighbours = [live, dead, live, live, dead, live]
          expect(@cell.lives? neighbours).to be(false)
        end
      end
    end

    context 'cell is dead' do
      before(:each) { cell.set_alive(false) }
      context 'with exactly 3 live neighbours' do
        it 'lives' do
          neighbours = [live, dead, live, live]
          expect(@cell.lives? neighbours).to be(true)
        end
      end

      it 'dies otherwise' do
        neighbours = [live, dead, live, dead]
        expect(@cell.lives? neighbours).to be(false)

        neighbours = [live, dead, live, dead, live, live]
        expect(@cell.lives? neighbours).to be(false)
      end
    end
  end

  describe '#ancestor_alive?' do
    context 'cell is root' do
      it 'returns true' do
        expect(cell.ancestor_alive?).to be(true)
      end
    end

    it 'returns false if not all ancestors are alive' do
      cell_1 = Cell.new(false, 1)
      cell_2 = Cell.new(true, 2)

      cell_1.parent = cell
      cell_2.parent = cell_1

      expect(cell_2.ancestor_alive?).to be(false)
    end

    it 'returns true if all ancestors are alive' do
      cell_1 = Cell.new(true, 1)
      cell_2 = Cell.new(true, 2)

      cell_1.parent = cell
      cell_2.parent = cell_1

      expect(cell_2.ancestor_alive?).to be(true)
    end
  end
end
