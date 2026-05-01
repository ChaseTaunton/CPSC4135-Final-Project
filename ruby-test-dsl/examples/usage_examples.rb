require_relative '../lib/test_framework'
require_relative 'simple_calculator'
require_relative 'login_service'

# Simple usage examples for each assertion method
test_suite "Basic Usage" do
  test "Test if two values are equal" do
    expect(5).to_equal(5)
  end

  test "Test if a value is greater than another" do
    expect(10).to_be_greater_than(5)
  end

  test "Test if a value is less than another" do
    expect(5).to_be_less_than(10)
   end

  test "Test if a string includes a substring" do
    expect("Hello, world!").to_include("world")
  end

  test "Test if a value is true" do
    expect(true).to_be_true
  end

  test "Test if a value is false" do
    expect(false).to_be_false
  end

  test "Test if a block raises an error" do
    expect { raise StandardError }.to_raise(StandardError)
  end

  test "Test if two arrays match" do
    expect([1, 2, 3]).to_match([1, 2, 3])
  end

  test "Test if an assertion method works correctly" do
    results = [
      Proc.new{expect(10).to_equal(10, true)}, 
      Proc.new{expect(10).to_equal(5, true)}
    ]
    expected = [true, false]
    expect(results).to_match(expected)
  end
end

# Practical usage examples for a simple Calculator app
test_suite "Calculator Tests" do
  setup do
    @calc = Calculator.new
    @value = 10
  end

  test "Addition works correctly" do
    expect(@calc.add(@value, 5)).to_equal(15)
  end

  test "Subtraction works correctly" do
    expect(@calc.subtract(@value, 5)).to_equal(5)
  end

  test "Multiplication works correctly" do
    expect(@calc.multiply(@value, 5)).to_equal(50)
  end

  test "Division works correctly" do
    expect(@calc.divide(@value, 5)).to_equal(2)
  end

  test "Division by zero raises error" do
    expect{@calc.divide(@value, 0)}.to_raise(ZeroDivisionError)
  end

  test "Value plus itself is greater than value" do
    expect(@calc.add(@value, @value)).to_be_greater_than(@value)
  end

  test "Value minus itself is less than value" do
    expect(@calc.subtract(@value, @value)).to_be_less_than(@value)
  end

  test "Intentional Failing Test" do
    expect(@calc.multiply(@value, 5)).to_equal(20)
  end
end


# Practical usage examples for a simple LoginService app
test_suite "Login Tests" do
  setup do
    @ls = LoginService.new
  end

  test "Valid login succeeds" do
    expect(@ls.login("admin", "password123")).to_be_true
  end

  test "Invalid password fails login" do
    expect(@ls.login("admin", "wrong")).to_be_false
  end

  test "Unknown user fails login" do
    expect(@ls.login("unknown", "password123")).to_be_false
  end

  test "Existing user is recognized" do
    expect(@ls.user_exists("admin")).to_be_true
  end

  test "Non-existent user is rejected" do
    expect(@ls.user_exists("unknown")).to_be_false
  end

  test "Admin access works" do
    expect(@ls.require_admin("admin")).to_be_true
  end

  test "Non-admin access raises error" do
    expect{@ls.require_admin("user1")}.to_raise(RuntimeError)
  end

  test "Strong password is recognized" do
    expect(@ls.password_strength("secure123")).to_equal("strong")
  end

  test "Weak password is recognized" do
    expect(@ls.password_strength("123")).to_equal("weak")
  end

  test "Intentional failing test" do
    expect(@ls.login("user1", "password123")).to_be_true
  end
end