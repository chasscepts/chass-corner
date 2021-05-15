class Category < ApplicationRecord
  has_many :articles
  has_many :article_categories, dependent: :destroy
  has_many :articles, through: :article_categories

  has_one :latest_article, class_name: 'Article', primary_key: :latest_article_id, foreign_key: :id

  scope :with_latest_article, lambda {
    select(
      "categories.*,
      (
        SELECT article_id as latest_article_id
        FROM article_categories
        WHERE category_id = categories.id
        ORDER BY created_at DESC
        LIMIT 1
      )"
    )
  }

  validates :name, presence: true, uniqueness: true

  validates :priority, presence: true
end
