class CreatePhotos < ActiveRecord::Migration[7.0]
  def change
    create_table :photos do |t|
      t.string :photoLink
      t.string :photoDescription
      t.string :photoType
      t.string :photoPageLocation

      t.timestamps
    end
  end
end
