class Cell
  attr_accessor :parent

  private
    attr_writer :alive, :level
  public
    attr_reader :alive, :level

    def initialize(alive = false, level = 0)
      self.alive = alive
      self.level = level
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

    def ancestor_alive?
      ancestor = self.parent
      while !ancestor.nil?
        return false if !ancestor.alive
        ancestor = ancestor.parent
      end
      true
    end

end
