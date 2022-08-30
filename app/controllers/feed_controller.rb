class FeedController < ApplicationController
  include HasRemarkSearch

  def show
    remark_search(params)
    render :show
  end
end
