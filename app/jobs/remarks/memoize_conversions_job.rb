class Remarks::MemoizeConversionsJob < ApplicationJob
  queue_as :remarks

  def perform(remark)
    remark.update({
      conversions_cache: remark.searches.group(:query).count,
      conversions_cache_updated_at: Time.now,
    })
  end
end
