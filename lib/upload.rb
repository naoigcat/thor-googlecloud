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
      directories = Pathname.new("../uploads").expand_path(__dir__).glob("*")
      files_by_directory = directories.to_h { |directory| [directory, directory.glob("*")] }
      files = files_by_directory.values.flatten
      normalization_plan = Pathname.normalization_plan(files)

      Cloud.login
      Cloud.exec("gcloud config set project #{@project}")
      normalized_files = files.zip(Pathname.apply_normalization(normalization_plan)).to_h

      files_by_directory.each do |directory, files|
        puts directory
        bucket = directory.basename.to_path
        files.each do |file|
          Cloud.exec("gsutil cp \"#{normalized_files.fetch(file)}\" gs://#{bucket}")
        end
      end
    end
  end
end
