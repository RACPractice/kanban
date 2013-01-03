class CreateUsersAccounts < ActiveRecord::Migration
  def change
    create_table :users_accounts do |t|
			t.references :user, :account
			t.boolean :is_invite_sent,	:null => false, :default => 0
			t.boolean :is_member,	:null => false, :default => 0
			t.boolean :is_owner,	:null => false, :default => 0
      t.timestamps
		end

		add_index :users_accounts, [:user_id, :account_id]
  end
end
