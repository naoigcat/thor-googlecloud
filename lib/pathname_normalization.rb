require "pathname"
require_relative "normalization_plan"
require_relative "string_normalization"

class Pathname
  # Validate every path before renaming to prevent partial changes caused by a collision.
  def self.normalize_all(paths)
    apply_normalization(normalization_plan(paths))
  end

  # Separate collision validation from file changes so callers can control when side effects occur.
  def self.normalization_plan(paths)
    NormalizationPlan.build(paths.map(&:to_path))
  end

  # Apply a prepared normalization plan separately so renaming can wait until prerequisites succeed.
  def self.apply_normalization(entries)
    entries.each do |source, target|
      Pathname.new(source).rename(target) unless source == target
    end

    entries.map { |_source, target| Pathname.new(target) }
  end
end
