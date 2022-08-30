class Users::CreateAvatarDerivativesJob < ApplicationJob
  queue_as :photos # TODO: different queue?

  def perform(user)
    user.avatar_attacher.remove_derivatives(:thumbnails, delete: user.avatar(:thumbnails).present?)
    user.avatar_attacher.create_derivatives
    user.save!
  end
end
