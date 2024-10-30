class RenameAndModifyPhotosTable < ActiveRecord::Migration[7.0]
  def change
    rename_column :photos, :photoDescription, :photo_description
    rename_column :photos, :photoType, :photo_type
    rename_column :photos, :image_url, :url
    remove_column :photos, :photoLink, :string
  end
end
