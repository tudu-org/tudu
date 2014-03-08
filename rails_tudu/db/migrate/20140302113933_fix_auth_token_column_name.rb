class FixAuthTokenColumnName < ActiveRecord::Migration
  def change
    rename_column :users, :authentication_token, :auth_token
  end
end
