class Remarks::ReindexRecordJob < ApplicationJob
  queue_as :remarks

  def perform(remark)
    remark.reindex(mode: :inline)
    html = RemarksController.render(partial: "remarks/remark", locals: { remark: remark })
    ActionCable.server.broadcast("remarks", { remark: html })
  end
end
