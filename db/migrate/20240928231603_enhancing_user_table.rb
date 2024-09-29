class EnhancingUserTable < ActiveRecord::Migration[7.0]
  def change
    change_table :users do |t|
      t.string :phone_number
      t.integer :class_year
      t.date :ring_date
      t.date :grad_date
      t.date :birthday
      t.string :shirt_size
      t.string :dietary_restriction
      t.boolean :account_complete, default: false
    end
  end
end
