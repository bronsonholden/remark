class AddThemePreferenceToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :theme_preference, :string
  end
end
