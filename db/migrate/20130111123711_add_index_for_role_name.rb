class AddIndexForRoleName < ActiveRecord::Migration
  def up
    add_index :roles, :name
  end

  def down
    remove_index :roles, :name
  end
end
