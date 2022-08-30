class ImageUploader < Shrine
  Attacher.derivatives :thumbnail do |original|
    magick = ImageProcessing::MiniMagick.source(original)
    thumbnail = magick.colorspace("sRGB").quality(85).resize_to_fit(478, 1400)
    {
      thumbnail: thumbnail.convert("webp").call,
      thumbnail_placeholder: thumbnail.convert("webp").blur("0x8").quality(30).resize_to_fit(239, 700).call,
      thumbnail_png: thumbnail.convert("png").call
    }
  end

  Attacher.derivatives :converted do |original|
    magick = ImageProcessing::MiniMagick.source(original)
    {
      converted: magick.convert("webp").define("webp:lossless=true").quality(100).call,
      converted_png: magick.convert("png").quality(100).call
    }
  end

  Attacher.validate do
    validate_max_size 15.megabytes
    validate_mime_type %w[image/jpeg image/png image/webp image/heic image/heif]
  end
end
