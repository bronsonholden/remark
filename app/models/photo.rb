class Photo < ApplicationRecord
  include ImageUploader::Attachment(:image)

  belongs_to :remark

  def remark_display_image
    image(:converted) || image
  end

  def remark_display_url
    remark_display_image.url
  end

  def remark_display_width
    remark_display_image&.metadata["width"] || 0
  end

  def remark_display_height
    remark_display_image&.metadata["height"] || 0
  end

  def safe_version_url(version)
    image(version)&.url || image_url
  end
end
