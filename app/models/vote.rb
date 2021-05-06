class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :article

  scope :most_voted_article, -> { select(:article_id, 'Max COUNT(article_id)').group(:article_id).include(:article) }
end
