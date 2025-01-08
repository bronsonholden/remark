class RemarksController < ApplicationController
  include HasRemarkSearch

  before_action :require_admin, only: [:debug, :nlp, :reindex, :conversions_cache, :photo_recognition]
  before_action :require_login, only: [:new, :create]
  before_action :set_remark, only: [:show, :debug, :reindex, :nlp, :conversions_cache, :photo_recognition]

  def new
    @remark = current_user.remarks.build
    render locals: { search_enabled: false }
  end

  def index
    remark_search(params)
  end

  def create
    photos_image_attributes = params.fetch(:image_data, []).inject({}) do |hash, image_data|
      hash.merge!(SecureRandom.hex => {image_data_uri: image_data})
    end

    @remark = current_user.remarks.build(remark_params.merge({photos_attributes: photos_image_attributes}))
    if @remark.save
      flash.discard
      @remark.photos.each { |photo| Photos::CreateDerivativesJob.perform_later(photo) }
      @remark.reindex(mode: :inline)
      redirect_to :feed
    else
      flash[:error] = @remark.errors.full_messages.to_sentence
      render :new, status: :unprocessable_entity
    end
  end

  def show
    # remark_search({ similar: params.require(:id) })
    @remarks = []
    render layout: "remark"
  end

  def debug
    flash.discard
    render layout: "remark"
  end

  def reindex
    @remark.reindex(mode: :inline)
    redirect_to debug_remark_path(@remark)
  end

  def conversions_cache
    Remarks::MemoizeConversionsJob.perform_now(@remark)
    redirect_to debug_remark_path(@remark)
  end

  def nlp
    Remarks::NlpJob.perform_now(@remark)
    redirect_to debug_remark_path(@remark)
  end

  def photo_recognition
    @remark.photos.each do |photo|
      Photos::RecognitionJob.perform_later(photo)
    end
  end

  private

  def remark_params
    params.require(:remark).permit(:user_id, :content)
  end

  def set_remark
    @remark = Remark.find(params.require(:id))
  rescue ActiveRecord::RecordNotFound => e
    flash[:error] = e.message
    redirect_to feed_path
  end
end
