require "minitest/autorun"
require "stringio"
require_relative "../lib/normalize"

class NormalizeTest < Minitest::Test
  def test_call_does_not_move_objects_when_normalized_names_collide
    commands = []
    queries = []
    objects = StringIO.new("gs://bucket/e\u0301.txt\ngs://bucket/é.txt\n")
    pipe = lambda do |command, &block|
      queries << command
      block.call(objects)
    end

    Cloud.stub(:login, nil) do
      Cloud.stub(:exec, ->(command) { commands << command }) do
        Cloud.stub(:pipe, pipe) do
          assert_raises(NormalizationPlan::CollisionError) do
            Cloud::Normalize.call("project", "bucket")
          end
        end
      end
    end

    assert_equal ["gsutil ls gs://bucket/**"], queries
    refute commands.any? { |command| command.start_with?("gsutil mv") }
  end
end
