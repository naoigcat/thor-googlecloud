require "minitest/autorun"
require_relative "../lib/normalization_plan"
require_relative "../lib/string_normalization"

class NormalizationPlanTest < Minitest::Test
  def test_build_returns_normalized_names
    decomposed = "e\u0301.txt"

    assert_equal [[decomposed, "é.txt"]], NormalizationPlan.build([decomposed])
  end

  def test_build_rejects_names_that_normalize_to_the_same_value
    decomposed = "e\u0301.txt"

    assert_raises(NormalizationPlan::CollisionError) do
      NormalizationPlan.build([decomposed, "é.txt"])
    end
  end
end
