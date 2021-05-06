class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :article, counter_cache: true

  # scope :most_votes, -> { select(:article_id, 'Max COUNT(article_id)').group(:article_id) }
  # scope :most_votes, -> { group(:article_id).count.max_by{|k,v| v}.first }
  scope :most_votes, -> { group(:article).count.max }
end
