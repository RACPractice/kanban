class ChangeDefaultStepCapacityTo10 < ActiveRecord::Migration
  def up
  	change_column :steps, :capacity, :integer, :default => 10, :null => false
  end

  def down
  end
end
