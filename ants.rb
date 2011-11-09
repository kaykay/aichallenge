# Ants AI Challenge framework
# by Matma Rex (matma.rex@gmail.com)
# Released under CC-BY 3.0 license

# Represents a single ant.
class Ant
	# Owner of this ant. If it's 0, it's your ant.
	attr_accessor :owner
	# Square this ant sits on.
	attr_accessor :square
	
	attr_accessor :alive, :ai
	
	def initialize alive, owner, square, ai
		@alive, @owner, @square, @ai = alive, owner, square, ai
	end
	
	# True if ant is alive.
	def alive?; @alive; end
	# True if ant is not alive.
	def dead?; !@alive; end
	
	# Equivalent to ant.owner==0.
	def mine?; owner==0; end
	# Equivalent to ant.owner!=0.
	def enemy?; owner!=0; end
	
	# Returns the row of square this ant is standing at.
	def row; @square.row; end
	# Returns the column of square this ant is standing at.
	def col; @square.col; end
	
	# Order this ant to go in given direction. Equivalent to ai.order ant, direction.
	def order direction
		@ai.order self, direction
	end
end

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
end












