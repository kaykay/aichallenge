# Represent a single field of the map.
class Square
  Directions = [:N, :E, :W, :S]
  # Ant which sits on this square, or nil. The ant may be dead.
  attr_accessor :ant
  # Which row this square belongs to.
  attr_accessor :row
  # Which column this square belongs to.
  attr_accessor :col

  #Maintain heuristic for various food locations to use in A* search,
  #this would have dest/food square as key and no.of steps as value
  attr_accessor :food_steps
  
  attr_accessor :water, :food, :hill, :ai

  attr_accessor :visible
  
  def initialize water, food, hill, ant, row, col, ai
    @water, @food, @hill, @ant, @row, @col, @ai = water, food, hill, ant, row, col, ai
    @food_steps = {}
    @visible = false
  end
  
  # Returns true if this square is not water. Square is passable if it's not water, it doesn't contain alive ants and it doesn't contain food.
  def land?; !@water; end
  # Returns true if this square is water.
  def water?; @water; end
  # Returns true if this square contains food.
  def food?; @food; end
  # Returns owner number if this square is a hill, false if not
  def hill?; @hill; end
  # Returns true if this square has an alive ant.
  def ant?; @ant and @ant.alive?; end;

  def visible?; @visible; end
  # Returns a square neighboring this one in given direction.
  def neighbor direction
    direction=direction.to_s.upcase.to_sym # canonical: :N, :E, :S, :W
    
    case direction
    when :N
      row, col = @ai.normalize @row-1, @col
    when :E
      row, col = @ai.normalize @row, @col+1
    when :S
      row, col = @ai.normalize @row+1, @col
    when :W
      row, col = @ai.normalize @row, @col-1
    else
      raise 'incorrect direction'
    end
    
    return @ai.map[row][col]
  end

  #Looks at http://aichallenge.org/specification.php Distance section
  #for details on how to calculate visibility. It returns true if
  #another_sq is within this squares visibility radius.
  def in_radius?(another_sq, radius2)
    dr = [(this.row - another_sq.row).abs,(@ai.rows - (another_sq.row - this.row).abs) ].min
    dc = [(this.col - another_sq.col).abs,(@ai.cols - (another_sq.col - this.col).abs) ]
    (dr**2 + dc**2) <= radius2
  end
  
  # Normalized row and col
  def nrow
    @nrow ||= row % @ai.rows
  end

  def ncol
    @ncol ||= col % @ai.cols
  end

  def wrap_row(r)
    if r < 0
      @ai.rows + r
    else
      r % @ai.rows
    end
  end

  def wrap_col(c)
    if c < 0
      @ai.cols + c
    else
      c % @ai.cols
    end
  end
  
  #naive distance
  def distance(dest_square)
    dcol = [(ncol - dest_square.ncol).abs, @ai.cols - (ncol - dest_square.ncol)].min
    drow = [(nrow - dest_square.nrow).abs, @ai.rows - (nrow - dest_square.nrow)].min
    dcol + drow
  end
  
  #Which direction to head towards, it will at most give next 2
  #copied python implementation
  #directions to go to.
  
  def direction(dest_square)
    d = []
    if(nrow < dest_square.nrow)
      if((dest_square.nrow - nrow) >= (@ai.rows/2))
        d << :N
      else
        d << :S
      end
    end
    if(nrow > dest_square.nrow)
      if((nrow - dest_square.nrow) >= (@ai.rows/2))
        d << :S
      else
        d << :N
      end
    end
    if(ncol < dest_square.ncol)
      if((dest_square.ncol - ncol) >= (@ai.cols/2))
        d << :W
      else
        d << :E
      end
    end
    if(ncol > dest_square.ncol)
      if((ncol - dest_square.ncol) >= (@ai.cols/2))
        d << :E
      else
        d << :W
      end
    end
    d
  end
  
  def update_adjacent_scores(fs)
    food_steps_inc = @food_steps[fs] + 1
    need_update = []
    Directions.each do |dir|
      adj_sq = neighbor(dir)
      next if(!adj_sq || !adj_sq.visible? || adj_sq.water? || adj_sq.food_steps.keys.include?(fs))
      adj_sq.food_steps[fs] = food_steps_inc
      need_update << adj_sq
    end
    need_update
  end

  def adj_square_directions
    dists = []
    Directions.each do |dir|
      adj_sq = neighbor(dir)
      break if !adj_sq
      adj_sq.food_steps.each do |food_sq, num_steps|
        dists << [num_steps, self, food_sq, dir]
      end
    end
    dists
  end
  
  def opposite(dir)
    case(dir)
    when :N then :S
    when :S then :N
    when :E then :W
    when :W then :E
    end
  end
  
  #update @visible for all the visible squares that are approximately
  #in view radius, doing this so that its cost effective.
  def update_approx_visibility(viewradius)
    vr = viewradius.ceil
    ltr, ltc = (self.row - vr), (self.col - vr)
    rtr, rtc = (self.row + vr ), (self.col + vr)
    (ltr..rtr).each do |rw|
      (ltc..rtc).each do |cl|
        @ai.map[wrap_row(rw)][wrap_col(cl)].visible = true
      end
    end
  end
  
end
