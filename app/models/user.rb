class User < ApplicationRecord
  include Clearance::User
  include AvatarUploader::Attachment(:avatar)

  validates_confirmation_of :password
  validates_presence_of :first_name
  validates_presence_of :last_name

  has_many :remarks
  has_many :reactions
  has_many :reacted_remarks, through: :reactions, source: :remark
  has_many :photos, through: :remarks

  def full_name
    "#{first_name} #{last_name}".strip.presence
  end

  def thumbnail_url(size)
    return nil unless avatar.present?
    if avatar(:thumbnails, size).present?
      avatar(:thumbnails, size).url
    else
      avatar_url
    end
  end
end
