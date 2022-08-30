class ControlPanelController < ApplicationController
  before_action :require_admin

  def show
    @elastic_search = Searchkick.client
    render :show, locals: { search_enabled: false }
  end
end
