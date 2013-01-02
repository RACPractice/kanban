class CreateWorkItems < ActiveRecord::Migration
  def change
    create_table :work_items do |t|
			t.string :name
			t.string :slug
			t.text :description
			t.references :project
			t.references :work_item
			t.references :work_type
			t.references :priority
			t.integer :work_value
			t.integer :position
			t.boolean :is_ready
			t.boolean :is_blocked
			t.integer :requested_by
			t.integer :assigned_to
			t.date :target_date
			t.date :completion_date
      t.timestamps
		end

		add_index :work_items, :project_id
		add_index :work_items, :work_item_id
		add_index :work_items, :work_type_id
		add_index :work_items, :priority_id

  end
end
