class AddVisibleToRequiredInProjects < ActiveRecord::Migration
  def up
    change_column :projects, :visible, :boolean, :null => false, :default => false
  end

  def down
    change_column :projects, :visible, :boolean
  end
end
