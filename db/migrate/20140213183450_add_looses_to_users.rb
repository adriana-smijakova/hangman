class AddLoosesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :looses, :integer
  end
end
