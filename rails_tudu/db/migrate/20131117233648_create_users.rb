class CreateUsers < ActiveRecord::Migration
  def change
  	create_table :users do |t|
  		t.string :email
      t.string :password
      t.string :password_confirmation
      t.boolean :terms_of_service
  		t.string :password_salt
      t.string :password_hash
      t.string :authentication_token
  	end
  end
end
