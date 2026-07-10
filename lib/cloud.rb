require "shellwords"
require_relative "pathname_normalization"
require_relative "string_normalization"

module Cloud
  class << self
    def login
      return unless pipe("gcloud config get account", &:read).empty?

      exec "gcloud auth login"
    end

    def logout
      return if pipe("gcloud config get account", &:read).empty?

      exec "gcloud auth revoke && rm -fr /root/.config/gcloud"
    end

    def exec(command, _mode = "r", _opt = {}, &)
      system("#{sshpass} #{command.shellescape}")
    end

    def pipe(command, mode = "r", opt = {}, &)
      IO.popen("#{sshpass} #{command.shellescape}".tap(&method(:puts)), mode, opt, &)
    end

    private

    def sshpass
      "sshpass -p secret ssh -o StrictHostKeyChecking=no root@googlecloud"
    end
  end
end
