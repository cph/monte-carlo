class Algorithm
  attr_reader :features

  def initialize(features)
    @features = features
  end

  def minimum_cost
    @minimum_cost ||= features.map(&:begin).sum
  end

  def maximum_cost
    @maximum_cost ||= features.map(&:end).sum
  end

  def average_cost
    @average_cost ||= (minimum_cost + maximum_cost) / 2.0
  end

  def standard_deviation
    @standard_deviation ||= [minimum_cost, maximum_cost, average_cost].stdevp
  end

  def minimum_iterations
    @minimum_iterations ||= begin
      ε = average_cost / 50
      ((3 * standard_deviation / ε) ** 2).round
    end
  end

  def iterations
    @iterations ||= minimum_iterations.times.map { guess_cost }
  end

  def expected_cost
    iterations.mean
  end

private

  def guess_cost
    features.map { |range| random.rand(range) }.sum
  end

  def random
    @random ||= Random.new
  end

end
