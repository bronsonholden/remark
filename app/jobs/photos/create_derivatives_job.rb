# Create missing derivatives for a photo. Set `force` to true
# to remove existing derivatives and generate new ones
class Photos::CreateDerivativesJob < ApplicationJob
  queue_as :photos

  def perform(photo, options = {})
    if options[:force] == true
      photo.image_attacher.derivatives.keys.each { |key| photo.image_attacher.remove_derivatives(key, delete: true) }
    end
    photo.image_attacher.create_derivatives(:thumbnail) if photo.image(:thumbnail).blank?
    photo.image_attacher.create_derivatives(:converted) if photo.image(:converted).blank?
    photo.save!
  end
end
