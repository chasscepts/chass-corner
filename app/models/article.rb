class Article < ApplicationRecord
  belongs_to :author, class_name: 'User', foreign_key: :author_id, inverse_of: :articles
  has_many :article_categories, dependent: :destroy
  has_many :categories, through: :article_categories
  has_many :votes, dependent: :destroy

  scope :most_voted, -> { order('votes_count') }
  scope :most_recent_first, -> { order('created_at DESC') }

  validates :author_id, presence: true
  validates :title, presence: true, length: { minimum: 10 }
  validates :text, presence: true, length: { minimum: 300 }
  validates :image, presence: true

  def categories_text
    @categories_text ||= categories.map(&:name).join(', ')
  end
end
