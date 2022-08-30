class CreatePhotos < ActiveRecord::Migration[7.0]
  def change
    create_table :photos do |t|
      t.references :remark, foreign_key: true
      t.text :caption
      t.jsonb :image_data
      t.timestamps
    end
  end
end
