class CreateArticles < ActiveRecord::Migration[6.1]
  def change
    create_table :articles do |t|
      t.references :author, null: false, foreign_key: { to_table: :users }
      t.string :title
      t.references :category, null: false, foreign_key: true
      t.string :image

      t.timestamps
    end
  end
end
