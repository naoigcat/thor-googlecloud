require_relative "cloud"

module Cloud
  module Logout
    module_function

    def call
      Cloud.logout
    end
  end
end
