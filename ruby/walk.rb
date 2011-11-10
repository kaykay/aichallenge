class Walk
  attr_reader :orders, :ai, :targets

  def initialize(ai)
    @ai = ai
    @orders = {}
    @targets = {}
  end
  def not_taken?(loc)
    !@orders.has_key?(loc)
  end
  

  def move_location(ant_loc, dest)
    dirs = ant_loc.direction(dest)
    warn "directions : #{dirs}"
    dirs.each do |dir|
      if(move_direction(ant_loc, dir))
        warn "Move direction [#{ant_loc.row}, #{ant_loc.col}], #{dir}"
        targets[dest] = ant_loc
        return true
      else
        false
      end
    end
  end
  
  def move_direction(ant_loc, dir)
    new_loc = ant_loc.neighbor dir
    if(!new_loc.ant? && not_taken?(new_loc) && new_loc.land?)
      ant_loc.ant.order dir
      @orders[new_loc] = ant_loc
      true
    else
      false
    end
  end
  
  def walk
    @ai.my_ants.each do |ant|
      [:N, :E, :S, :W].each do |dir|
        break if move_direction(ant.square, dir)  
      end
    end
  end

  def food_walk
    ant_dist = []
    @ai.food_squares.each do |fs|
      @ai.my_ants.each do |ant|
        dist = ant.square.distance(fs)
        ant_dist << [dist, ant.square, fs]
      end
      ant_dist.sort do |a, b|
        a[0] <=> b[0]
      end
      ant_dist.each do |dist, ant_loc, food_loc|
        if (!@targets.keys.include?(food_loc) && !@targets.values.include?(ant_loc))
          move_location(ant_loc, food_loc)
        #  warn "Move location, #{ant_loc}, #{food_loc}"
        end
      end
    end
  end
  
  def random_directions
    dirs = [:N, :E, :S, :W]
    new_dirs = []
    while !dirs.empty?
      n = dirs[rand(dirs.size)]
      new_dirs << n
      dirs.delete(n)
    end
    new_dirs
  end
  
  def random_walk
    @ai.my_ants.each do |ant|
      random_directions.each do |dir|
        break if move_direction(ant.square, dir)  
      end
    end
  end
  
  def old_walk
    @ai.my_ants.each do |ant|
      # try to go north, if possible; otherwise try east, south, west.
      [:N, :E, :S, :W].each do |dir|
        if ant.square.neighbor(dir).land?
          ant.order dir
          break
        end
      end
    end
  end
end
