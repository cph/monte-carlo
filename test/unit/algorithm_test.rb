require "test_helper"

# if mixing worker, get into same unit, multiply by hourly rate

class AlgorithmTest < ActiveSupport::TestCase
  attr_reader :algorithm

  setup do
    @algorithm = Algorithm.new([8..24, 32..96])
  end

  context "#minimum_cost" do
    should "be the sum of the features' best-case scenarios" do
      assert_equal 40, algorithm.minimum_cost
    end
  end

  context "#maximum_cost" do
    should "be the sum of the features' best-case scenarios" do
      assert_equal 120, algorithm.maximum_cost
    end
  end

  context "#average_cost" do
    should "be the halfway point between the minimum and maximum costs" do
      assert_equal 80, algorithm.average_cost
    end
  end

  context "#standard_deviation" do
    should "be the standard deviation of the min, max, and average cost" do
      assert_equal [40, 80, 120].stdevp, algorithm.standard_deviation
      assert_equal 32, algorithm.standard_deviation.floor, "Should match Jeremy's spreadsheet"
    end
  end

  context "#minimum_iterations" do
    should "get the same result at Jeremy's spreadsheet" do
      assert_equal 3750, algorithm.minimum_iterations
    end
  end

  context "#iterations" do
    should "generate hypothetical costs as many times as #minimum_iterations dictates" do
      assert_equal algorithm.minimum_iterations, algorithm.iterations.length
    end

    should "generate hypothetical costs that are between the best-case and worst-case, inclusive" do
      range = algorithm.minimum_cost..algorithm.maximum_cost
      assert algorithm.iterations.all? { |cost| range.cover?(cost) }
    end
  end

  context "#expected_cost" do
    should "be the average of the iterations" do
      assert_equal algorithm.iterations.mean, algorithm.expected_cost
    end
  end

end
