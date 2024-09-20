class CreateEducations < ActiveRecord::Migration[7.0]
  def change
    create_table :educations do |t|
      t.string :educationName
      t.string :educationType
      t.string :educationDescription

      t.timestamps
    end
  end
end
