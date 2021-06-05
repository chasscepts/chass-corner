class ArticleCategory < ApplicationRecord
  belongs_to :article
  belongs_to :category

  scope :latest_in_categories, -> { select('DISTINCT ON (category_id) *').order('category_id, created_at DESC') }

  scope :most_recent_article, -> { Article.where('articles.id=article_categories.id order by created_at DESC limit 1') }
end
