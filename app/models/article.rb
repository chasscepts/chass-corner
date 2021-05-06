class Article < ApplicationRecord
  belongs_to :author, class_name: 'User', foreign_key: :author_id, inverse_of: :articles
  belongs_to :category
  has_many :votes, dependent: :destroy

  scope :in_category, ->(category) { where(category: category) }
  scope :latest, -> { order('order by created_at desc') }
end
