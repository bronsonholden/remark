class Article < ApplicationRecord
  validates_presence_of :title
  validates_presence_of :source
  validates :slug, presence: true, uniqueness: true

  belongs_to :author, class_name: "User"

  enum status: {draft: 0, published: 1, archived: 2}

  before_save :set_published_at, if: :will_save_change_to_status?

  def source_html
    markdown = Redcarpet::Markdown.new(
      TailwindHtmlRenderer.new,
      autolink: true,
      prettify: true,
      tables: true,
      fenced_code_blocks: true
    )
    markdown.render(source)
  end

  def to_param
    slug
  end

  def updated_since_publish?
    published? && updated_at > published_at
  end

  private

  def set_published_at
    if published?
      self.updated_at = self.published_at = Time.now
    elsif draft?
      self.published_at = nil
    end
  end
end
