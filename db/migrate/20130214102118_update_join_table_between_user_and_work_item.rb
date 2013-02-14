class UpdateJoinTableBetweenUserAndWorkItem < ActiveRecord::Migration
  def up
  	drop_table :users_work_items
  	create_table :users_work_items, :id => false do |t|
		t.references :user, :work_item
	end
	add_index :users_work_items, [:user_id, :work_item_id]
  end

  def down
  end
end
