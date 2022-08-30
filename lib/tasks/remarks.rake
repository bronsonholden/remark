namespace :remarks do
  desc "Rebuild index"
  task rebuild_index: :environment do
    Remark.all.each do |remark|
      Remarks::NlpJob.perform_now(remark)
      Remarks::MemoizeConversionsJob.perform_now(remark)
    end
    Remark.reindex(mode: :inline)
  end

  desc "Clean indices"
  task clean_indices: :environment do
    Remark.search_index.clean_indices
  end

  desc "Reindex remarks"
  task reindex: :environment do
    Remark.reindex
  end

  desc "Start a background job to process search index queue"
  task start_process_queue_job: :environment do
    Searchkick::ProcessQueueJob.perform_later(class_name: "Remark")
  end

  desc "Update NLP data for all Remarks"
  task update_nlp_data: :environment do
    Remark.where(nlp: nil).each do |remark|
      Remarks::NlpJob.perform_later(remark)
    end
  end

  desc "Update conversions cache for all Remarks"
  task memoize_conversions_caches: :environment do
    Remark.all.each do |remark|
      Remarks::MemoizeConversionsJob.perform_later(remark)
    end
  end
end
