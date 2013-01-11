class AddRoleReferenceToMembers < ActiveRecord::Migration
	def up
		add_column :members, :role_id, :integer, :after => :account_id
		add_index :members, :role_id
	end

  def down
		remove_column :members, :role_id
		remove_index :members, :role_id
	end
end
