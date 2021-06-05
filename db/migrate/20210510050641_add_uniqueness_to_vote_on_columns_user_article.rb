class AddUniquenessToVoteOnColumnsUserArticle < ActiveRecord::Migration[6.1]
  def change
    add_index :votes, [:user_id, :article_id], unique: true
  end
end
