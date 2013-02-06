class ChangeStepCapacityTo50ByDefault < ActiveRecord::Migration
  def change
  	change_column :steps, :capacity, :integer, :null => false, :default => 50
  end
end
