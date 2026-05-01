require_relative '../lib/test_framework'

# Uses the test framework to check that the assertion methods work correctly
test_suite "Framework Assertion Tests" do
  test "Check that the \"to_equal\" assertion works" do
    results = [
      Proc.new{expect(10).to_equal(10, true)}, 
      Proc.new{expect(10).to_equal(5, true)}
    ]
    expected = [true, false]
    expect(results).to_match(expected)
  end

  test "Check that the \"to_be_greater_than\" assertion works" do
    results = [
      Proc.new{expect(15).to_be_greater_than(10, true)}, 
      Proc.new{expect(5).to_be_greater_than(10, true)}
    ]
    expected = [true, false]
    expect(results).to_match(expected)
  end

  test "Check that the \"to_be_less_than\" assertion works" do
    results = [
      Proc.new{expect(5).to_be_less_than(10, true)}, 
      Proc.new{expect(15).to_be_less_than(10, true)}
    ]
    expected = [true, false]
    expect(results).to_match(expected)
  end

  test "Check that the \"to_include\" assertion works" do
    results = [
      Proc.new{expect("This is a string").to_include("str", true)}, 
      Proc.new{expect("This is a string").to_include("xyz", true)}, 
      Proc.new{expect("This is a string").to_include("this", true)},
      Proc.new{expect([1, 2, 3]).to_include(2, true)},
      Proc.new{expect([1, 2, 3]).to_include(4, true)}
    ]
    expected = [true, false, false, true, false]
    expect(results).to_match(expected)
  end

  test "Check that the \"to_be_true\" assertion works" do
    results = [
      Proc.new{expect(true).to_be_true(true)},
      Proc.new{expect(false).to_be_true(true)}
    ]
    expected = [true, false]
    expect(results).to_match(expected)
  end

  test "Check that the \"to_be_false\" assertion works" do
    results = [
      Proc.new{expect(false).to_be_false(true)},
      Proc.new{expect(true).to_be_false(true)}
    ]
    expected = [true, false]
    expect(results).to_match(expected)
   end

  test "Check that the \"to_raise\" assertion works" do
    results = [
      Proc.new{expect{10/0}.to_raise(ZeroDivisionError, true)},
      Proc.new{expect{raise ArgumentError}.to_raise(ArgumentError, true)},
      Proc.new{expect{10/1}.to_raise(ZeroDivisionError, true)},
      Proc.new{expect{10/0}.to_raise(ArgumentError, true)}
    ]
    expected = [true, true, false, false]
    expect(results).to_match(expected)
  end
end