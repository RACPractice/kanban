class CreateMemberships < ActiveRecord::Migration
  def change
    create_table :memberships do |t|
			t.references :user, :account
			t.boolean :invite_sent,	:null => false, :default => false
			t.boolean :member,	:null => false, :default => false
			t.boolean :owner,	:null => false, :default => false
			t.timestamps
		end

		add_index :memberships, [:user_id, :account_id]

  end
end

