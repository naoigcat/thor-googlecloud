require "minitest/autorun"
require "tmpdir"
require_relative "../lib/pathname_normalization"

class PathnameNormalizationTest < Minitest::Test
  # Ensure collision-free paths are renamed without changing their contents.
  def test_normalize_all_renames_every_path_after_validation
    Dir.mktmpdir do |directory|
      source = Pathname.new(directory).join("e\u0301.txt")
      source.write("content")

      normalized = Pathname.normalize_all([source])

      assert_equal [Pathname.new(directory).join("é.txt")], normalized
      assert_equal "content", normalized.first.read
    end
  end

  # Ensure preflight validation preserves both files when their normalized names collide.
  def test_normalize_all_does_not_rename_any_path_when_names_collide
    Dir.mktmpdir do |directory|
      decomposed = Pathname.new(directory).join("e\u0301.txt")
      composed = Pathname.new(directory).join("é.txt")
      decomposed.write("decomposed")
      composed.write("composed")

      skip "The filesystem does not preserve distinct NFD and NFC names" if Pathname.new(directory).children.size < 2

      assert_raises(NormalizationPlan::CollisionError) do
        Pathname.normalize_all([decomposed, composed])
      end

      assert_equal "decomposed", decomposed.read
      assert_equal "composed", composed.read
    end
  end
end
