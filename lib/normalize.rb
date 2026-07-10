require_relative "cloud"

module Cloud
  class Normalize
    def self.call(project, bucket)
      new(project, bucket).call
    end

    def initialize(project, bucket)
      @project = project
      @bucket = bucket
    end

    def call
      Cloud.login
      Cloud.exec("gcloud config set project #{@project}")
      Cloud.pipe("gsutil ls gs://#{@bucket}", &:readlines).map(&:chomp).reject do |file|
        file == file.normalized
      end.each do |file|
        Cloud.exec("gsutil mv #{file.shellescape} #{file.normalized.shellescape}")
        sleep 1
      end
    end
  end
end
