class SplashController < ApplicationController
  layout "splash"

  def show
    redirect_to feed_path if signed_in?
  end
end
