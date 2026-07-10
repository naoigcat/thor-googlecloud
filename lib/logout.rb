require_relative "cloud"

module Cloud
  class Logout
    def self.call
      Cloud.logout
    end
  end
end
