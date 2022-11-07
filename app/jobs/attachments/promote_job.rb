class Attachments::PromoteJob
  include Sidekiq::Worker

  def perform(attacher_class, record_class, record_id, name, file_data)
    attacher_class = Object.const_get(attacher_class)
    record = Object.const_get(record_class).find(record_id)
    attacher = attacher_class.retrieve(model: record, name: name, file: file_data)
    attacher.atomic_promote
  rescue Shrine::AttachmentChanged, ActiveRecord::RecordNotFound
  end
end
