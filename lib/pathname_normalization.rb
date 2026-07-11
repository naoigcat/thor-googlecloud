require "pathname"
require_relative "normalization_plan"
require_relative "string_normalization"

class Pathname
  # Validate the complete set first so a collision cannot leave partially renamed files.
  def self.normalize_all(paths)
    apply_normalization(normalization_plan(paths))
  end

  def self.normalization_plan(paths)
    NormalizationPlan.build(paths.map(&:to_path))
  end

  def self.apply_normalization(entries)
    entries.each do |source, target|
      Pathname.new(source).rename(target) unless source == target
    end

    entries.map { |_source, target| Pathname.new(target) }
  end
end
