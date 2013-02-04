class DropOldColumnsFromMembers < ActiveRecord::Migration
  def up
    remove_column :members, :member
    remove_column :members, :owner
  end

  def down
    add_column :members, :member, :boolean, :default => false, :null => false
    add_column :members, :owner, :boolean, :default => false, :null => false
  end
end
