class RemoveCreatedAtAndUpdatedAtInProjectSteps < ActiveRecord::Migration
  def up
    remove_column :projects_steps, :created_at
    remove_column :projects_steps, :updated_at
  end

  def down
  end
end
