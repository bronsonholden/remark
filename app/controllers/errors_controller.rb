class ErrorsController < ApplicationController
  def show
    code = params.require(:code)
    render code.to_s, status: code
  end
end
