class SearchesController < ApplicationController
  layout false

  before_action :set_search

  def convert
    @search.convert(Remark.find(params.require(:remark_id)))
    head :ok
  end

  private

  def set_search
    @search = Searchjoy::Search.find(params.require(:id))
  end
end
