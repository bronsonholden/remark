class RemarksChannel < ApplicationCable::Channel
  def subscribed
    stream_from "remarks"
  end
end
