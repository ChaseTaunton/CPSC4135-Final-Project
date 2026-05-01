
# Ruby Test Framework DSL

## Project Description

This project implements a simple Domain-Specific Language (DSL) in Ruby for writing and executing tests. The DSL allows users to define test cases, group them into suites, and use custom assertions to confirm expected behavior with clean and readable syntax. 

The framework supports value comparisons, boolean checks, error checking, clearly formatted test execution, and result summaries for test suites.

---

## Features

- `test_suite` for grouping tests
- `setup` for sharing initialization
- `teardown` for cleaning up variables, state, files, temporary objects, etc.
- `test` for defining individual test cases
- Custom assertion methods:
  - `to_equal`
  - `to_be_greater_than`
  - `to_be_less_than`
  - `to_include`
  - `to_be_true`
  - `to_be_false`
  - `to_raise`
  - `to_match`
- PASS / FAIL output for each assertion
- Ability to run specific tests or entire suites
- Summary report showing passed and failed tests for test suites

---

## Project Structure  
  
```text  
ruby-test-dsl/
|	lib/  
|	L	test_framework.rb  
|	examples/  
|	|	usage_examples.rb  
|	|	assertion_tests.rb  
|	|	simple_calculator.rb  
L	L	login_service.rb  
```  
  
---

## How to Run

Run the usage examples:
```
ruby examples/usage_examples.rb
```

Run the framework assertion tests:
```
ruby examples/assertion_tests.rb
```

Run your own test file:
```
ruby *your/file/path*
```
*Make sure `require_relative  '..../lib/test_framework'` is at the top of your test file*

---
## Usage Examples

### Simple usage examples for each assertion method

```ruby

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
		expect { raise  StandardError }.to_raise(StandardError)
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
```

---

### Practical usage examples for a simple Calculator app

```ruby
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
```

---

### Practical usage examples for a simple LoginService app

```ruby
test_suite "Login Tests"  do
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
```

---

## Example Output

### Simple Calculator App

```text
==============================
~~~ Calculator Tests: 8 tests ~~~

Running: Addition works correctly
PASS - 15 equals 15

Running: Subtraction works correctly
PASS - 5 equals 5

Running: Multiplication works correctly
PASS - 50 equals 50

Running: Division works correctly
PASS - 2 equals 2

Running: Division by zero raises error
PASS - raised ZeroDivisionError as expected

Running: Value plus itself is greater than value
PASS - 20 is greater than 10

Running: Value minus itself is less than value
PASS - 0 is less than 10

Running: Intentional Failing Test
FAIL - expected 20, got 50

Calculator Tests Results:
7 passed
1 failed
8 total
==============================
```

---

## Assertion Reference

| Method | Description | Example |
|---|---|---|
| `to_equal(value)` | Checks if two values are equal | `expect(5).to_equal(5)` |
| `to_be_greater_than(value)` | Checks if one value is greater than another value | `expect(10).to_be_greater_than(5)` |
| `to_be_less_than(value)` | Checks if one value is less than another value | `expect(5).to_be_less_than(10)` |
| `to_include(value)` | Checks if a string, array, or collection includes a value | `expect("hello").to_include("ell")` |
| `to_be_true` | Checks if a value is `true` | `expect(true).to_be_true` |
| `to_be_false` | Checks if a value is `false` | `expect(false).to_be_false` |
| `to_raise(ErrorClass)` | Checks if a block raises a specific error | `expect { 10 / 0 }.to_raise(ZeroDivisionError)` |
| `to_match(array)` | Checks if two arrays match. Also, allows for testing custom assertion methods (see "Simple usage examples for each assertion method") | `expect([1, 2, 3]).to_match([1, 2, 3])` |


---

## Author

Chase Taunton
