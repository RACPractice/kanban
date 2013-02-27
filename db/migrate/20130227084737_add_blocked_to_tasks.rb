class AddBlockedToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :blocked, :boolean, :null => false, :default => false
  end
end
