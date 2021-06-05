class ChangeArticleImageColumnToForeignKey < ActiveRecord::Migration[6.1]
  def change
    rename_column :articles, :image, :image_id
  end
end
