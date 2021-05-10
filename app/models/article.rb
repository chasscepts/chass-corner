class Article < ApplicationRecord
  belongs_to :author, class_name: 'User', foreign_key: :author_id, inverse_of: :articles
  belongs_to :category
  has_many :votes, dependent: :destroy

  scope :latest_in_categories, -> { select('DISTINCT ON (category_id) *').order('category_id, created_at DESC') }
  scope :most_voted, -> { order('votes_count') }

  validates :category_id, presence: true
  validates :author_id, presence: true
  validates :title, presence: true, length: { minimum: 10 }
  validates :text, presence: true, length: { minimum: 300 }
  validates :image, presence: true
end
