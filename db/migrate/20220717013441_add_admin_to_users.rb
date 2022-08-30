class AddAdminToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :admin, :boolean

    User.update_all(admin: false)

    change_column_null :users, :admin, false
    change_column_default :users, :admin, false
  end
end
