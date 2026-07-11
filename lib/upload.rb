require_relative "cloud"

module Cloud
  class Upload
    # Keep construction and execution together so CLI entry points do not duplicate the workflow.
    def self.call(project)
      new(project).call
    end

    # Keep the project fixed on the instance so it cannot change during an upload.
    def initialize(project)
      @project = project
    end

    # Build the complete rename plan before authentication so a collision cannot cause partial changes.
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
