class AddUserTypeToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :userType, :string
  end
end
