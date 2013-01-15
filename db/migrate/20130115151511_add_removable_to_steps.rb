class AddRemovableToSteps < ActiveRecord::Migration
  def up
    add_column :steps, :removable, :boolean, :null => false, :default => true
  end

  def down
    remove_column :steps, :removable
  end
end
