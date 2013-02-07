class AddDefaultWorkValueInWorkItems < ActiveRecord::Migration
  def up
  	change_column :work_items, :work_value, :integer, :null => false, :default => 0
  end

  def down
  	change_column :work_items, :work_value, :integer
  end
end
