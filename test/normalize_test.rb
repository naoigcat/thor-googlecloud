require "minitest/autorun"
require "stringio"
require_relative "../lib/normalize"

class NormalizeTest < Minitest::Test
  # Ensure a collision found during preflight validation leaves Cloud Storage unchanged.
  def test_call_does_not_move_objects_when_normalized_names_collide
    commands = []
    queries = []

    stub_cloud_listing(commands, queries) do
      assert_raises(NormalizationPlan::CollisionError) do
        Cloud::Normalize.call("project", "bucket")
      end
    end

    assert_equal ["gsutil ls gs://bucket/**"], queries
    refute(commands.any? { |command| command.start_with?("gsutil mv") })
  end

  private

  # Record Cloud commands while returning colliding NFC and NFD object names.
  def stub_cloud_listing(commands, queries, &)
    Cloud.stub(:login, nil) do
      Cloud.stub(:exec, ->(command) { commands << command }) do
        Cloud.stub(:pipe, colliding_object_pipe(queries), &)
      end
    end
  end

  # Provide a gsutil ls response that includes both Unicode forms of the same name.
  def colliding_object_pipe(queries)
    objects = StringIO.new("gs://bucket/e\u0301.txt\ngs://bucket/é.txt\n")
    lambda do |command, &block|
      queries << command
      block.call(objects)
    end
  end
end
