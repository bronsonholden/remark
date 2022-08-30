class CreateArticles < ActiveRecord::Migration[7.0]
  def change
    create_table :articles do |t|
      t.text :title, null: false
      t.text :source, null: false
      t.string :slug, null: false
      t.references :author, foreign_key: { to_table: :users }
      t.integer :status, null: false, default: 0
      t.datetime :published_at
      t.timestamps
    end
  end
end
