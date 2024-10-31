class AddProjectToPhotos < ActiveRecord::Migration[7.0]
  def change
    add_reference :photos, :project, foreign_key: true
    remove_column :photos, :photoPageLocation, :string
    add_column :photos, :displayed_in_home_gallery, :boolean
  end
end
