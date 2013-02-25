class AddWorkItemIndexForTasks < ActiveRecord::Migration
  def up
  	add_index :tasks, :work_item_id
  end

  def down
  end
end
