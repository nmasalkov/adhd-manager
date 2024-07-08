class AddLuckIndexToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :luck_index, :integer, default: 0
  end
end
