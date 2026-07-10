require_relative "cloud"

module Cloud
  class Upload
    def self.call(project)
      new(project).call
    end

    def initialize(project)
      @project = project
    end

    def call
      Cloud.login
      Cloud.exec("gcloud config set project #{@project}")
      Pathname.new("../uploads").expand_path(__dir__).glob("*").each do |directory|
        puts directory
        bucket = directory.basename.to_path
        directory.glob("*").each do |file|
          Cloud.exec("gsutil cp \"#{file.normalized.to_path}\" gs://#{bucket}")
        end
      end
    end
  end
end
