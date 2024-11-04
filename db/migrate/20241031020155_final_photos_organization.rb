class FinalPhotosOrganization < ActiveRecord::Migration[7.0]
  def change
    remove_column :photos, :photo_type
    rename_column :photos, :photo_description, :description
  end
end
