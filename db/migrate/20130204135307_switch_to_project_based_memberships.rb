class SwitchToProjectBasedMemberships < ActiveRecord::Migration
  def up
    create_table :memberships do |t|
      t.references :user, :project, :role
      t.boolean :invite_sent,	:null => false, :default => false
      t.timestamps
    end

    Member.all.each do |member|
      member.account.projects.each do |project|
        Membership.create! :user        => member.user,
                           :project     => project,
                           :role        => member.role,
                           :invite_sent => member.invite_sent
      end
    end

    add_column :accounts, :owner_id, :integer

    owner_role = Role.find_by_name("owner")
    Account.all.each do |account|
      account.update_attribute :owner_id, Member.find_by_account_id_and_role_id(account.id, owner_role.id).id
    end

    drop_table :members
  end

  def down
    #create_table :members do |t|
    #  t.references :user, :account, :role
    #  t.boolean :invite_sent,	:null => false, :default => false
    #  t.timestamps
    #end
    #
    #remove_column :accounts, :owner_id
    #
    #Membership.all.each do |membership|
    #  unless Member.find_by_user_id_and_account_id(membership.user.id, membership.project.account.id)
    #    Member.create! :user        => membership.user,
    #                   :account     => membership.project.account,
    #                   :role        => membership.role,
    #                   :invite_sent => membership.invite_sent
    #  end
    #end
    #
    #drop_table :memberships
  end
end
