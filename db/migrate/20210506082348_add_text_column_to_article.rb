class AddTextColumnToArticle < ActiveRecord::Migration[6.1]
  def change
    add_column :articles, :text, :text
  end
end
