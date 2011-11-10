# Represent a single field of the map.
class Square
  # Ant which sits on this square, or nil. The ant may be dead.
  attr_accessor :ant
  # Which row this square belongs to.
  attr_accessor :row
  # Which column this square belongs to.
  attr_accessor :col
  
  attr_accessor :water, :food, :hill, :ai
  
  def initialize water, food, hill, ant, row, col, ai
    @water, @food, @hill, @ant, @row, @col, @ai = water, food, hill, ant, row, col, ai
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

  # Normalized row and col
  def nrow
    @nrow ||= row % @ai.rows
  end

  def ncol
    @ncol ||= col % @ai.cols
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

end
