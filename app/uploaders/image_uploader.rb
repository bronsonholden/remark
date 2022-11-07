class ImageUploader < Shrine
  # add_metadata skip_nil: true do |io|
  #   mime = Shrine.mime_type(io)
  #   tmp = Tempfile.new("movie")
  #   tmp.write(io)
  #   if mime.start_with?("video")
  #     nil
  #   else
  #     movie = FFMPEG::Movie.new(tmp.path)
  #     {
  #       width: movie.width,
  #       height: movie.height
  #     }
  #   end
  # end

  Attacher.derivatives :thumbnail do |original|
    mime = Shrine.mime_type(original)

    if mime.start_with?("image")
      magick = ImageProcessing::MiniMagick.source(original)
      thumbnail = magick.colorspace("sRGB").quality(100).resize_to_fit(478, 1400)
      {
        thumbnail: thumbnail.convert("webp").call,
        thumbnail_png: thumbnail.convert("png").call
      }
    elsif mime.start_with?("video")
      tmp = Tempfile.new(["thumbnail", ".png"])
      movie = FFMPEG::Movie.new(original.path)
      movie.screenshot(tmp.path, { seek_time: 0 })
      magick = ImageProcessing::MiniMagick.source(tmp)
      thumbnail = magick.colorspace("sRGB").quality(100).resize_to_fit(478, 1400)
      {
        thumbnail: thumbnail.convert("webp").call,
        thumbnail_png: thumbnail.convert("png").call
      }
    end
  end

  Attacher.derivatives :converted do |original|
    magick = ImageProcessing::MiniMagick.source(original)
    mime = Shrine.mime_type(original)

    if mime.start_with?("image")
      {
        converted: magick.convert("webp").define("webp:lossless=true").quality(100).call,
        converted_png: magick.convert("png").quality(100).call
      }
    elsif mime.start_with?("video")
      {}
    end
  end

  Attacher.validate do
    validate_max_size 15.megabytes
    validate_mime_type %w[image/jpeg image/png image/webp image/heic image/heif video/quicktime]
  end

  Attacher.promote_block do
    Attachments::PromoteJob.perform_async(self.class.name, record.class.name, record.id, name, file_data)
  end

  Attacher.destroy_block do
    Attachments::DestroyJob.perform_async(self.class.name, data)
  end
end
