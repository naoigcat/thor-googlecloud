#!/usr/bin/env ruby
require "bundler"
Bundler.require
Pathname.glob("lib/**.rb").each(&method(:load))

module Cloud
  class << self
    require "shellwords"

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

class Pathname
  def normalized
    parent.join(to_path.normalized.tap(&method(:rename)))
  end
end

class String
  def normalized
    unicode_normalize(:nfc)
  end
end

Entrypoint.start
