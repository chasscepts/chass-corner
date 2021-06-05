class UndoChangesToArticleImage < ActiveRecord::Migration[6.1]
  def change
    change_table :articles do |t|
      t.remove :image_id
      t.string :image
    end
  end
end
