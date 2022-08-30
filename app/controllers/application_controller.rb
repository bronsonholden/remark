class ApplicationController < ActionController::Base
  include Clearance::Controller
  include Pagy::Backend

  def require_admin
    require_login
    if current_user
      redirect_to feed_path unless current_user.admin?
    end
  end
end
