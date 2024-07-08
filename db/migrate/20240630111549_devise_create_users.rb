# frozen_string_literal: true

class DeviseCreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :login, null: false
      t.string :encrypted_password, null: false

      t.timestamps null: false
    end

    add_index :users, :login, unique: true
  end
end
