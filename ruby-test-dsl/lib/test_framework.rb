class Expectation
  # Initializes the Expectation object with either an actual value or a block of code to be tested.
  def initialize(actual = nil, block = nil)
    @actual = actual
    @block = block
  end

  # Defines an assertion method to check if the actual value equals the expected value.
  def to_equal(expected, silent = false)
    if @actual == expected
      pass("#{@actual} equals #{expected}") unless silent
      return true
    else
      fail("expected #{expected}, got #{@actual}") unless silent
      return false
    end
  end

  # Defines an assertion method to check if the actual value is greater than the expected value.
  def to_be_greater_than(expected, silent = false)
    if @actual > expected
      pass("#{@actual} is greater than #{expected}") unless silent
      return true
    else
      fail("expected #{@actual} to be greater than #{expected}") unless silent
      return false
    end
  end

  # Defines an assertion method to check if the actual value is less than the expected value.
  def to_be_less_than(expected, silent = false)
    if @actual < expected
      pass("#{@actual} is less than #{expected}") unless silent
      return true
    else
      fail("expected #{@actual} to be less than #{expected}") unless silent
      return false
    end
  end

  # Defines an assertion method to check if the actual value includes the expected value.
  def to_include(expected, silent = false)
    if @actual.include?(expected)
      pass("#{@actual} includes #{expected}") unless silent
      return true
    else
      fail("expected #{@actual} to include #{expected}") unless silent
      return false
    end
  end

  # Defines an assertion method to check if the actual value is true.
  def to_be_true(silent = false)
    if @actual == true
      pass("expected true, got true") unless silent
      return true
    else
      fail("expected true, got #{@actual}") unless silent
      return false
    end
  end

  # Defines an assertion method to check if the actual value is false.
  def to_be_false(silent = false)
    if @actual == false
      pass("expected false, got false") unless silent
      return true
    else
      fail("expected false, got #{@actual}") unless silent
      return false
    end
  end

  # Defines an assertion method to check if the block of code raises the expected error.
  def to_raise(expected, silent = false)
    begin
      @block.call
      fail("expected #{expected}, but no error was raised") unless silent
      return false
    rescue expected
      pass("raised #{expected} as expected") unless silent
      return true
    rescue StandardError => e
      fail("expected #{expected}, but got #{e.class}") unless silent
      return false
    end
  end

  # Defines an assertion method to check if the actual array matches the expected array (can be used to check if assertion methods work correctly).
  def to_match(expected)
    if @actual.size != expected.size
      fail("expected array of size #{expected.size}, got #{@actual.size}")
      return false
    end

    counter = 0
    @actual.each_with_index do |element, index|
      if !element.is_a?(Proc)
        if element == expected[index]
          counter += 1       
        end
      else
        if element.call == expected[index]
          counter += 1
        end
      end
    end

    if counter == expected.size
      pass("#{counter} out of #{expected.size} elements matched")
      return true
    else        
      fail("only #{counter} out of #{expected.size} elements matched")
      return false
    end
  end

  def pass(message)
    puts "PASS - #{message}"
  end

  def fail(message)
    puts "FAIL - #{message}"
  end
end

# Defines the method to create an expectation object for a given actual value or block of code.
def expect(actual = nil, &block)
  if block
    Expectation.new(nil, block)
  else
    Expectation.new(actual)
  end
end

# Defines a method to run an individual test case with a given name.
def test(name)
  puts "Running: #{name}"
  begin
    yield
  rescue StandardError => e
    puts "ERROR - #{e.class}: #{e.message}"
  end
end

class TestSuite
  # Initializes the TestSuite object with a name, nil setup and teardown blocks, an empty array for tests, and counters for passed and failed tests.
  def initialize(name)
    @name = name
    @setup_block = nil
    @teardown_block = nil
    @tests = []
    @passed = 0
    @failed = 0
  end

  # Defines a block of code that runs before each test in the test suite.
  # Used to initialize shared data or state needed by tests.
  def setup(&block)
    @setup_block = block
  end

  # Defines a block of code that runs after each test in the test suite.
  # Used to clean up shared data or state after tests.
  def teardown(&block)
    @teardown_block = block
  end

  # Defines a test case with a given name and block of code to be executed as the test.
  def test(name, &block)
    @tests << {name: name, block: block}
  end

  # Runs all the tests in the test suite, executing the setup block before each test and the teardown block after each test.
  def run
    puts "=============================="
    puts "~~~ #{@name}: #{@tests.size} tests ~~~"
    puts 

    # Iterates through each test case, running the setup block, executing the test block, and then running the teardown block. 
    # Also counts the number of passed and failed tests based on whether exceptions are raised during test execution.
    @tests.each do |test_case|
      instance_eval(&@setup_block) if @setup_block
      puts "Running: #{test_case[:name]}"

      begin
        result = instance_eval(&test_case[:block])

        if result == false
          @failed += 1
        else
          @passed += 1
        end
        
      rescue StandardError => e
        puts "ERROR - #{e.class}: #{e.message}"
        @failed += 1
      end

      instance_eval(&@teardown_block) if @teardown_block

      puts
    end

    print_summary
  end

  # Prints a summary of the test results.
  def print_summary
    total = @passed + @failed

    puts "#{@name} Results:"
    puts "#{@passed} passed"
    puts "#{@failed} failed"
    puts "#{total} total"
    puts "=============================="
    puts 
  end
end

# Defines a method to create and run a test suite with a given name and block of code containing the test definitions.
def test_suite(name, &block)
  suite = TestSuite.new(name)
  suite.instance_eval(&block)
  suite.run
end