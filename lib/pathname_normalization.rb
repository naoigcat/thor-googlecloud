require "pathname"
require_relative "string_normalization"

class Pathname
  # Keep the renamed entry and returned path aligned with the same normalized name.
  def normalized
    parent.join(to_path.normalized.tap(&method(:rename)))
  end
end
