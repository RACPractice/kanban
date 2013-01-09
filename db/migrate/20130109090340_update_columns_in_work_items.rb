class UpdateColumnsInWorkItems < ActiveRecord::Migration
  def up
    remove_index :work_items, :project_id
    remove_column :work_items, :project_id
    change_column :work_items, :step_id, :integer, :null => false
    change_column :work_items, :is_blocked, :boolean, :null => false, :default => false
  end

  def down
    add_column :work_items, :project_id, :integer
    add_index :work_items, :project_id
    change_column :work_items, :step_id, :integer
    change_column :work_items, :is_blocked, :boolean
  end
end
