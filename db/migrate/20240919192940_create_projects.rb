# frozen_string_literal: true

class CreateProjects < ActiveRecord::Migration[7.0]
  def change
    create_table :projects do |t|
      t.string :projectName
      t.string :projectDesc
      t.integer :locationID
      t.date :projectStartDate
      t.boolean :isProjectActive

      t.timestamps
    end
  end
end
