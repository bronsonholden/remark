class Photo < ApplicationRecord
  include ImageUploader::Attachment(:image)

  belongs_to :remark

  def remark_display_url
    thumbnail = image(:thumbnail)
    return thumbnail.url if thumbnail.present?
    image(:converted).url
  end

  def remark_display_width
    thumbnail = image(:thumbnail)
    return thumbnail.metadata["width"] if thumbnail.present?
    image.metadata["width"]
  end

  def remark_display_height
    thumbnail = image(:thumbnail)
    return thumbnail.metadata["height"] if thumbnail.present?
    image.metadata["height"]
  end
end
