class CreateUsers < ActiveRecord::Migration

  def change
    create_table :users do |t|
      t.string :email
      t.string :encrypted_password
      t.integer :role, default: 0
      t.string :reset_password_token
      t.datetime :reset_password_sent_at
      t.string :remember_token
      t.datetime :remember_created_at

      t.timestamps null: false
    end

    add_index :users, [:remember_token]
    add_index :users, [:reset_password_token]
    add_index :users, [:email], unique: true
  end

end
