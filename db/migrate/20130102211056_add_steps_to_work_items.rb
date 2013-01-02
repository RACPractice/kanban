class AddStepsToWorkItems < ActiveRecord::Migration
  def change
		change_table :work_items do |t|
			t.references :step, :after => :priority_id
		end

		add_index :work_items, :step_id

	end

end
