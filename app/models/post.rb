class Post < ApplicationRecord
  include FriendlyId
  friendly_id :post, use: [:slugged, :finders]
  belongs_to :topic
  belongs_to :participant
  has_many :votes, as: :votable
  before_validation :cache_rendered_markdown

  validates :vote_count, presence: true

  def should_generate_new_friendly_id?
    post_changed?
  end

  private
  def cache_rendered_markdown
    if post_markdown_changed?
      self.post = RenderMarkdown.new.render(post_markdown)
    end
  end
end
