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

class TestSuite
  def initialize(name)
    @name = name
    @setup_block = nil
    @tests = []
  end

  def setup(&block)
    @setup_block = block
  end

  def test(name, &block)
    @tests << { name: name, block: block }
  end

  def run
    puts @name

    @tests.each do |test_case|
      instance_eval(&@setup_block) if @setup_block

      puts "Running: #{test_case[:name]}"
      instance_eval(&test_case[:block])
      puts
    end
  end
end

def test_suite(name, &block)
  suite = TestSuite.new(name)
  suite.instance_eval(&block)
  suite.run
end