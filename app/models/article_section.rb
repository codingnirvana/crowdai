class ArticleSection < ApplicationRecord
  include FriendlyId
  friendly_id :section, use: [:slugged, :finders]
  before_validation :cache_rendered_markdown

  belongs_to :article

  validates_presence_of :icon
  validates_presence_of :section
  validates_uniqueness_of :section, allow_blank: false, scope: :article

  default_scope { order('seq ASC') }


  ICONS = {
    'home' => 'Home',
    'list-alt' => 'List',
    'book' => 'Book',
    'star' => 'Star',
    'equalizer' => 'Equalizer',
    'arrow-up' => 'Arrow Up',
    'arrow-right' => 'Arrow Right',
    'arrow-left' => 'Arrow Left',
    'arrow-down' => 'Arrow Down',
    'random' => 'Random',
    'signal' => 'Signal',
    'inbox' => 'Inbox',
    'pencil' => 'Pencil',
    'cog' => 'Cog',
    'dashboard' => 'Dashboard',
    'retweet' => 'Cycle',
    'pause' => 'Pause',
    'wrench' => 'Wrench',
    'tasks' => 'Tasks',
    'filter' => 'Filter'
  }

  def should_generate_new_friendly_id?
    section_changed?
  end


  private
  def cache_rendered_markdown
    if description_markdown_changed?
      self.description = RenderMarkdown.new.render(description_markdown)
    end
  end

end
