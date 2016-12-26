require 'chingu'
# Any live cell with fewer than two live neighbours dies, as if caused by underpopulation.
# Any live cell with two or three live neighbours lives on to the next generation.
# Any live cell with more than three live neighbours dies, as if by overpopulation.
# Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.
#
# The initial pattern constitutes the seed of the system.
# The first generation is created by applying the above rules simultaneously to every cell in the seed—births
# and deaths occur simultaneously,
# and the discrete moment at which this happens is sometimes called a tick
# (in other words, each generation is a pure function of the preceding one).
# The rules continue to be applied repeatedly to create further generations.

class CellRenderer < Chingu::GameObject
  def setup
    self.image = "mars_07.png"
    self.scale = 0.25
  end

  def update
  end

  def live_or_die?
  end
end

class Cell
 private
  attr_writer :alive

 public
  attr_reader :alive

  def initialize(alive = false)
    self.alive = alive
  end

  def set_alive(val)
    self.alive = val
  end

  def lives?(neighbours)
    alive_count = neighbours.count { |n| n.alive }

    if !self.alive
      return alive_count == 3
    end

    alive_count.between? 2, 3
  end
end
