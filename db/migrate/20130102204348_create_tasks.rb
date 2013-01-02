class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
			t.string :name
			t.string :slug
			t.text :description
			t.references :work_item
			t.boolean :is_completed
			t.date :completed_at
      t.timestamps
		end

		add_index :tasks, :work_item_id

  end
end
