#!/usr/bin/env ruby
require "bundler"
Bundler.require
Pathname.glob("lib/**.rb").each(&method(:load))

module Cloud
  require "shellwords"

  module_function

  def login
    return unless pipe("gcloud config get account", &:read).empty?
    exec "gcloud auth login"
  end

  def logout
    return if pipe("gcloud config get account", &:read).empty?
    exec "gcloud auth revoke && rm -fr /root/.config/gcloud"
  end

  def exec(command, mode = "r", opt = {}, &block)
    system("sshpass -p secret ssh -o StrictHostKeyChecking=no root@googlecloud #{command.shellescape}")
  end

  def pipe(command, mode = "r", opt = {}, &block)
    IO.popen("sshpass -p secret ssh -o StrictHostKeyChecking=no root@googlecloud #{command.shellescape}".tap(&method(:puts)), mode, opt, &block)
  end
end

class String
  def normalized
    unicode_normalize(:nfc)
  end
end

Entrypoint.start
