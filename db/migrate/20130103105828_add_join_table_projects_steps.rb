class AddJoinTableProjectsSteps < ActiveRecord::Migration
  def up
		create_table :projects_steps do |t|
			t.references :project, :step
			t.timestamps
		end
		add_index :projects_steps, [:project_id, :step_id]
  end

  def down
		drop_table :projects_steps
  end
end
