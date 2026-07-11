require_relative "string_normalization"

class NormalizationPlan
  class CollisionError < StandardError; end

  # Build the complete plan and reject normalized-name collisions before callers make changes.
  def self.build(names)
    entries = names.map { |name| [name, name.normalized] }
    collisions = entries.group_by(&:last).select { |_name, sources| sources.size > 1 }

    unless collisions.empty?
      names = collisions.keys.join(", ")
      raise CollisionError, "Normalized names collide: #{names}"
    end

    entries
  end
end
