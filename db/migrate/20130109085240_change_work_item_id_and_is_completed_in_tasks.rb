class ChangeWorkItemIdAndIsCompletedInTasks < ActiveRecord::Migration
  def up
    change_column :tasks, :work_item_id, :integer, :null => false
    change_column :tasks, :is_completed, :boolean, :null => false, :default => false
    add_index :tasks, :is_completed
  end

  def down
    change_column :tasks, :work_item_id, :integer
    change_column :tasks, :is_completed, :boolean
    remove_index :tasks, :is_completed
  end
end
