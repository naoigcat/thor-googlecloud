class Entrypoint < Thor
  desc "logout", "Logout from Google Cloud"
  def logout
    Cloud.logout
  end
end
