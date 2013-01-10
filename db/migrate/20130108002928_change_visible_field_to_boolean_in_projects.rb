class ChangeVisibleFieldToBooleanInProjects < ActiveRecord::Migration
  def up
    remove_column :projects, :visible
    add_column :projects, :visible, :boolean , :after => :account_id
  end

  def down
  end
end
