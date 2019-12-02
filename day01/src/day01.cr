module Day01
  VERSION = "0.1.0"

  class Runner
    property masses : Array(Int32)

    def initialize(input)
      @masses = File.read_lines(input).map(&.to_i)
    end

    def part1
      run(->Fuel.required(Int32))
    end

    def part2
      run(->Fuel.total_required(Int32))
    end

    private def run(method)
      @masses.map(&method).sum
    end
  end

  module Fuel
    extend self

    def required(mass : Int32)
      calc = (mass / 3) - 2
      Math.max(calc, 0)
    end

    def total_required(mass : Int32, acc = 0)
      fuel = required(mass)
      
      case fuel
      when .zero?
        acc
      else
        total_required(fuel, acc + fuel)
      end
    end
  end

  def self.run
    runner = Day01::Runner.new("data/input.txt")
    puts runner.part1
    puts runner.part2
  end
end