class RenameUserTypeToUserTypeInUsers < ActiveRecord::Migration[7.0]
  def change
    rename_column :users, :userType, :user_type
  end
end
