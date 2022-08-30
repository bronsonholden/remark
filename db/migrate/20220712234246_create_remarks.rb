class CreateRemarks < ActiveRecord::Migration[7.0]
  def change
    create_table :remarks do |t|
      t.text :content, null: false
      t.references :user, null: false, foreign_key: true
      t.references :remark, foreign_key: true
      t.timestamps
    end
  end
end
