class Walk
  attr_reader :orders, :ai

  def initialize(ai)
    @ai = ai
    @orders = {}
  end
  def not_taken?(loc)
    @orders.has_key?(loc)
  end
  
  def move_direction(ant_loc, dir)
    new_loc = ant_loc.neighbour dir
    if(!new_loc.ant? && not_taken?(new_loc) && new_loc.land?)
      @ai.order ant_loc.ant, dir
      @orders[new_loc] = ant_loc
      true
    else
      false
    end
  end
  
  def walk
    ai.ants.each do |ant|
      [:N, :E, :S, :W].each do |dir|
        break if move_direction(ant.square, dir)  
      end
    end
  end
end
