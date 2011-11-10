require 'square'

describe Square, "#direction" do
  it "returns right direction" do
    AI = Struct.new(:rows, :cols)
    ai = AI.new(16, 16)
    sq1 = Square.new(false, false, false, false, 5, 6, ai)
    sq2 = Square.new(false, false, false, false, 8, 8, ai)
    sq1.direction(sq2).should == [:S, :E]

    sq1 = Square.new(false, false, false, false, 5, 6, ai)
    sq2 = Square.new(false, false, false, false, 5, 8, ai)
    sq1.direction(sq2).should == [:E]
    
    sq1 = Square.new(false, false, false, false, 5, 8, ai)
    sq2 = Square.new(false, false, false, false, 8, 8, ai)
    sq1.direction(sq2).should == [:S]

  end

end

describe Square, "#distance" do
  it "returns right distance" do
    AI = Struct.new(:rows, :cols)
    ai = AI.new(16, 16)
    sq1 = Square.new(false, false, false, false, 5, 6, ai)
    sq2 = Square.new(false, false, false, false, 8, 8, ai)
    sq1.distance(sq2).should == 5
  end
end
