class ChangeArticleImageIdToTypeInteger < ActiveRecord::Migration[6.1]
  def change
    change_table :articles do |t|
      t.remove :image_id
      t.references :image, null: false, foreign_key: true
    end
  end
end
