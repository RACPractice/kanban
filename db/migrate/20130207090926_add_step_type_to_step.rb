class AddStepTypeToStep < ActiveRecord::Migration
  def change
    add_column :steps, :type, :string, :null => false, :default => 'custom', :limit => 25
  end
end
