require "./spec_helper"

alias Fuel = Day01::Fuel
alias Runner = Day01::Runner

describe Day01 do
  describe Fuel do
    it "calculates required fuel for mass" do
      Fuel.required(12).should eq(2)
      Fuel.required(14).should eq(2)
      Fuel.required(1969).should eq(654)
      Fuel.required(100756).should eq(33583)
    end

    it "calculates total required fuel for mass" do
      Fuel.total_required(12).should eq(2)
      Fuel.total_required(1969).should eq(966)
      Fuel.total_required(100756).should eq(50346)
    end
  end

  describe Runner do
    it "runs part 1" do 
      runner = Day01::Runner.new("data/input.txt")
      runner.part1.should eq(3392373)
    end
    
    it "runs part 2" do
      runner = Day01::Runner.new("data/input.txt")
      runner.part2.should eq(5085699) 
    end
  end
end

