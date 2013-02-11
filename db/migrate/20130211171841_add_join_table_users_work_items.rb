class AddJoinTableUsersWorkItems < ActiveRecord::Migration
  def up
    create_table :users_work_items do |t|
      t.references :user, :work_item
      t.timestamps
    end
    add_index :users_work_items, [:user_id, :work_item_id]
  end

  def down
    drop_table :users_work_items
  end
end
