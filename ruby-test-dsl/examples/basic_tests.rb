require_relative '../lib/test_framework'

test_suite "Basic Tests" do
  test "1 + 1 equals 2" do
    expect(1 + 1).to_equal(2)
  end

  test "2 * 2 equals 5" do
    expect(2 * 2).to_equal(5)
  end

  test "string comparison passes" do
    expect("ruby").to_equal("ruby")
  end

  test "string comparison fails" do
    expect("ruby").to_equal("python")
  end
end
