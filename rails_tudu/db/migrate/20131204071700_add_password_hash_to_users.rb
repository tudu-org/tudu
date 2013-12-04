class AddPasswordHashToUsers < ActiveRecord::Migration
  def change
    add_column :users, :password_hash, :string
  end
end
