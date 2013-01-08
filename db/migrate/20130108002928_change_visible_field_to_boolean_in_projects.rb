class ChangeVisibleFieldToBooleanInProjects < ActiveRecord::Migration
  def up
		change_column :projects, :visible, :boolean , :after => :account_id
  end

  def down
		change_column :projects, :visible, :string , :after => :account_id
  end
end
