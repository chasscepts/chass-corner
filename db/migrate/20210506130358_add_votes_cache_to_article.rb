class AddVotesCacheToArticle < ActiveRecord::Migration[6.1]
  def change
    add_column :articles, :votes_count, :integer, default: 0
    add_index :articles, :votes_count
  end
end
