require_relative "cloud"
require_relative "normalization_plan"

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
      files = Cloud.pipe("gsutil ls gs://#{@bucket}/**", &:readlines).map(&:chomp)

      NormalizationPlan.build(files).each do |source, target|
        next if source == target

        Cloud.exec("gsutil mv #{source.shellescape} #{target.shellescape}")
        sleep 1
      end
    end
  end
end
