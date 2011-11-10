$:.unshift File.dirname($0)
#require all ruby files in current directory
Dir.glob("*.rb").each {|f| require f }

$stderr.reopen("err.txt", "w")

ai=AI.new

ai.setup do |ai|
  # your setup code here, if any
end

ai.run do |ai|

  # your turn code here
  walk = Walk.new(ai)
  walk.random_walk
end