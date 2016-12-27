module Organism
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

  def next(grid)
  end

  def lives?(neighbours)
    alive_count = neighbours.count { |n| n.alive }

    if !self.alive
      return alive_count == 3
    end

    alive_count.between? 2, 3
  end
end
