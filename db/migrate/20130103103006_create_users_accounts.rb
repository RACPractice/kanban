class CreateUsersAccounts < ActiveRecord::Migration
  def change
    create_table :users_accounts do |t|
			t.references :user, :account
			t.boolean :is_invite_sent,	:null => false, :default => false
			t.boolean :is_member,	:null => false, :default => false
			t.boolean :is_owner,	:null => false, :default => false
      t.timestamps
		end

		add_index :users_accounts, [:user_id, :account_id]
  end
end
