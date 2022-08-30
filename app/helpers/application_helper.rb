module ApplicationHelper
  include Pagy::Frontend

  def social_meta_tags
    render "application/social_meta_tags"
  end
end
