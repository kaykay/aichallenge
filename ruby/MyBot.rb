$:.unshift File.dirname($0)
#require all ruby files in current directory
Dir.glob("*.rb").each {|f| require f if !(f =~ /spec/)}
Dir.glob("lib/*.rb").each {|f| require f if !(f =~ /spec/)}


$stderr.reopen("err.txt", "w")

STDOUT.sync = true
STDERR.sync = true

warn "got here"

ai=::AI.new

ai.setup do |ai|
  ai.known_food = ai.food_squares
  # your setup code here, if any
end

ai.run do |ai|

  # your turn code here
  walk = Walk.new(ai)
  walk.astar_walk
end
