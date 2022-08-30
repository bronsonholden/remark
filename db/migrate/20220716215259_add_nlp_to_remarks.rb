class AddNlpToRemarks < ActiveRecord::Migration[7.0]
  def change
    add_column :remarks, :nlp, :json
  end
end
