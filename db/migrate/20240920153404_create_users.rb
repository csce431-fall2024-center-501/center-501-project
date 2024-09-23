# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :full_name
      t.string :uid
      t.string :avatar_url
      t.string :user_type # Combined column for user type
      t.timestamps null: false
    end

    add_index :users, :email, unique: true
  end
end
