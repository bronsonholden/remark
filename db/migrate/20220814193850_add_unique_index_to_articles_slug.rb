class AddUniqueIndexToArticlesSlug < ActiveRecord::Migration[7.0]
  def change
    add_index :articles, :slug, unique: true
  end
end
