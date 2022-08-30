class AvatarUploader < Shrine
  Attacher.derivatives do |original|
    magick = ImageProcessing::MiniMagick.source(original)
    xs = magick.resize_to_fill(32, 32)
    sm = magick.resize_to_fill(64, 64)
    md = magick.resize_to_fill(128, 128)
    lg = magick.resize_to_fill(256, 256)
    {
      thumbnails: {
        xs: xs.convert("webp").quality(25).call,
        sm: sm.convert("webp").quality(75).call,
        md: md.convert("webp").quality(85).call,
        lg: lg.convert("webp").call,
        xs_png: xs.convert("png").quality(25).call,
        sm_png: sm.convert("png").quality(75).call,
        md_png: md.convert("png").quality(85).call,
        lg_png: lg.convert("png").call
      }
    }
  end

  Attacher.validate do
    validate_min_width 256
    validate_min_height 256
    validate_max_size 15.megabytes
    validate_mime_type %w[image/jpeg image/png image/webp image/heic image/heif]
  end
end
