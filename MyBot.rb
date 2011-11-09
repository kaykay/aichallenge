$:.unshift File.dirname($0)
#require all ruby files in current directory
Dir.glob("*.rb").each {|f| require f }


ai=AI.new

ai.setup do |ai|
  # your setup code here, if any
end

ai.run do |ai|
  # your turn code here
  
  ai.my_ants.each do |ant|
    # try to go north, if possible; otherwise try east, south, west.
    directions = [:N, :E, :S, :W]
    while !directions.empty?
      dir = directions[rand(directions.size)]
      directions = directions - [dir]
      
      if ant.square.neighbor(dir).open?
        ant.order dir
        break
      end
    end
  end
end
