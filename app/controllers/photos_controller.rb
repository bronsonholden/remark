class PhotosController < ApplicationController
  layout nil

  def show
    render Photo.find(params.require(:id))
  end
end
