class Entrypoint < Thor
  desc "upload [project]", "Upload files to Cloud storage"
  def upload(project)
    require "pathname"
    Cloud.login
    Cloud.exec("gcloud config set project #{project}")
    Pathname.new("../uploads").expand_path(__dir__).glob("*").each do |directory|
      puts directory
      bucket = directory.basename.to_path
      directory.glob("*").each do |file|
        Cloud.exec("gsutil cp \"#{file.normalized.to_path}\" gs://#{bucket}")
      end
    end
  end
end
