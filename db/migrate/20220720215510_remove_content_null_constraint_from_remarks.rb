class RemoveContentNullConstraintFromRemarks < ActiveRecord::Migration[7.0]
  def change
    change_column_null :remarks, :content, false
  end
end
