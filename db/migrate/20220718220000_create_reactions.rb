class CreateReactions < ActiveRecord::Migration[7.0]
  def change
    create_table :reactions do |t|
      t.references :remark, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :kind, null: false, default: 0
      t.timestamps
    end

    add_index :reactions, [:remark_id, :user_id, :kind], unique: true
  end
end
