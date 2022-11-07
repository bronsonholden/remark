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
Shrine.plugin :add_metadata
Shrine.plugin :backgrounding
Shrine.plugin :cached_attachment_data
Shrine.plugin :restore_cached_data
Shrine.plugin :data_uri
Shrine.plugin :derivatives
Shrine.plugin :determine_mime_type
Shrine.plugin :validation
Shrine.plugin :validation_helpers
Shrine.plugin :upload_options, store: {cache_control: "max-age=31536000"}

Shrine.plugin :store_dimensions, analyzer: -> (io, analyzers) do
  mime = Shrine.mime_type(io)
  if mime.start_with?("video")
    tmp = Tempfile.new("movie")
    tmp.binmode
    tmp.write(io.to_io.read)
    tmp.rewind
    movie = FFMPEG::Movie.new(tmp.path)
    dimensions = [movie.width, movie.height]
    video_stream = movie.metadata[:streams][0]
    video_stream.fetch(:side_data_list, []).each do |sd|
      if sd[:side_data_type] == "Display Matrix" && sd[:rotation] != 0
        dimensions = dimensions.reverse
      end
    end
    dimensions
  else
    analyzers[:fastimage].call(io)
  end
end
