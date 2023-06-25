class Entrypoint < Thor
  desc "normalize [project] [bucket]", "Normalize files of Cloud storage"
  def normalize(project, bucket)
    Cloud.login
    Cloud.exec("gcloud config set project #{project}")
    Cloud.pipe("gsutil ls gs://#{bucket}", &:readlines).map(&:chomp).reject do |file|
      file == file.normalized
    end.each do |file|
      Cloud.exec("gsutil mv #{file.shellescape} #{file.normalized.shellescape}")
      sleep 1
    end
  end
end
