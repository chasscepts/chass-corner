class User < ApplicationRecord
  has_many :articles, foreign_key: :author_id, inverse_of: :author
end
