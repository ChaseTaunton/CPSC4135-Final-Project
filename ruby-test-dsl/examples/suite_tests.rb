require_relative '../lib/test_framework'

test_suite "Calculator Tests" do
  setup do
    @value = 10
  end

  test "value stays the same" do
    expect(@value).to_equal(10)
  end

  test "value plus 5 equals 15" do
    expect(@value + 5).to_equal(15)
  end

  test "value times 2 equals 25" do
    expect(@value * 2).to_equal(25)
  end
end