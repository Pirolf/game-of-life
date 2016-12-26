require './spec/spec_helper'

RSpec.describe 'Cell' do
  require './src/cell'

  let(:cell) { @cell = Cell.new }

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
end
