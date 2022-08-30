class AddConversionsCacheToRemarks < ActiveRecord::Migration[7.0]
  def change
    add_column :remarks, :conversions_cache, :jsonb
    add_column :remarks, :conversions_cache_updated_at, :datetime
  end
end
