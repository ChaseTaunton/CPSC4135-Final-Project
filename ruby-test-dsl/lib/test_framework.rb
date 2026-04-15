class Expectation
  def initialize(actual)
    @actual = actual
  end

  def to_equal(expected)
    if @actual == expected
      puts "PASS"
    else
      puts "FAIL - expected #{expected}, got #{@actual}"
    end
  end
end

def expect(actual)
  Expectation.new(actual)
end

def test(name)
  puts "Running: #{name}"
  yield
  puts
end