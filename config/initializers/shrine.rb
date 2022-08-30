require "shrine"
require "shrine/storage/file_system"
require "shrine/storage/s3"

if Rails.env.production? || ENV["SHRINE_FORCE_S3"]
  options = {
    bucket: Rails.application.secrets.aws_s3_bucket,
    region: "us-east-1",
    access_key_id: Rails.application.secrets.aws_access_key_id,
    secret_access_key: Rails.application.secrets.aws_secret_access_key,
    public: true
  }
  Shrine.storages = {
    cache: Shrine::Storage::S3.new(prefix: "cache", **options),
    store: Shrine::Storage::S3.new(prefix: "store", **options)
  }
else
  Shrine.storages = {
    cache: Shrine::Storage::FileSystem.new("public", prefix: "uploads/cache"),
    store: Shrine::Storage::FileSystem.new("public", prefix: "uploads/store")
  }
end

Shrine.plugin :activerecord
Shrine.plugin :cached_attachment_data
Shrine.plugin :restore_cached_data
Shrine.plugin :derivatives
Shrine.plugin :determine_mime_type
Shrine.plugin :validation
Shrine.plugin :validation_helpers
Shrine.plugin :store_dimensions
Shrine.plugin :upload_options, store: {cache_control: "max-age=31536000"}
