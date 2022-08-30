class Remark < ApplicationRecord
  searchkick callbacks: :queue, word_start: %i[content], conversions: [:conversions]
  validate :content_or_photos

  has_many :conversions, class_name: "Searchjoy::Conversion", as: :convertable
  has_many :searches, class_name: "Searchjoy::Search", through: :conversions
  has_many :reactions
  has_many :photos, dependent: :destroy
  belongs_to :user

  accepts_nested_attributes_for :photos, allow_destroy: true

  def index_document
    Remark.search("*", where: {_id: id.to_s}, load: false).first
  end

  def search_data
    data = {
      indexed_at: Time.now,
      created_at: created_at,
      content: content,
      author: user.full_name,
      reactions: reaction_data,
      conversions: conversions_cache,
      user_id: user_id,
      photo_recognition: photo_recognition_data
    }
    if nlp.present?
      data.merge!({
        sentiment: nlp.fetch("sentiment", nil),
        key_phrases: nlp.fetch("key_phrases", []).map { |kp| kp["text"] }
      })
    end
    data
  end

  def similarity_input
    keywords = if nlp.present?
      nlp.fetch("key_phrases", []).map { |kp| kp["text"] }.presence || content
    else
      content
    end
    entities = nlp.fetch("entities", []).map { |entity| entity["text"] }.presence if nlp.present?
    photo_labels = photo_recognition_data.map do |recognition|
      recognition[:label]
    end
    [keywords, entities, conversions_cache&.keys, photo_labels].flatten.uniq.compact_blank
  end

  private

  def reaction_data
    reactions.includes(:user).map do |reaction|
      {
        id: reaction.id,
        kind: reaction.kind,
        user: {
          id: reaction.user_id,
          name: reaction.user.full_name
        },
        reacted_at: reaction.created_at
      }
    end
  end

  def photo_recognition_data
    photos.pluck(:recognition).compact.map do |recognition|
      recognition.fetch("labels", []).map do |label|
        if label.fetch("instances").present?
          {label: label["name"], confidence: label["confidence"] / 100}
        else
          {label: label["name"], confidence: label["confidence"] / 200}
        end
      end
    end.flatten.sort do |a, b|
      b[:confidence] - a[:confidence]
    end.map do |entry|
      entry[:confidence] = entry[:confidence].to_s
      entry
    end
  end

  def content_or_photos
    errors.add(:content, "must be provided") if photos.blank? && content.blank?
    errors.add(:photos, "limited to 10") if photos.length > 10
  end
end
