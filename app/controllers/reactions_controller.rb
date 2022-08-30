class ReactionsController < ApplicationController
  before_action :require_login, only: [:create, :destroy]
  before_action :set_remark
  before_action :set_reactions

  def index
  end

  def create
    current_user.reactions.like.where(remark: @remark).first_or_create!
    if params[:search_id]
      Searchjoy::Search.find(params[:search_id]).convert(@remark)
    end
    flash.discard
    render @remark.reload, turbo_frame: "remark-#{@remark.id}"
  rescue ActiveRecord::RecordNotUnique
    retry
  end

  def destroy
    @reactions.like.where(user: current_user).destroy_all
    render @remark.reload, turbo_frame: "remark-#{@remark.id}"
  end

  private

  def set_remark
    @remark = Remark.includes(:reactions).find(params.require(:id))
  rescue ActiveRecord::RecordNotFound => e
    flash[:error] = e.message
    render @remark, turbo_frame: "remark-#{@remark.id}"
  end

  def set_reactions
    @reactions = @remark.reactions
  end
end
