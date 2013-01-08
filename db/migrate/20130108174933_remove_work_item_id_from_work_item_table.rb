class RemoveWorkItemIdFromWorkItemTable < ActiveRecord::Migration
  def up
		remove_column :work_items, :work_item_id
  end

  def down
		add_column :work_items, :work_item_id, :integer, :after => :project_id
  end
end
