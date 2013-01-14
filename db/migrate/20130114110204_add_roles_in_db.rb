class AddRolesInDb < ActiveRecord::Migration
  def up
    Role.create(:name => 'owner') unless Role.where('name =?', 'owner').count > 0
    Role.create(:name => 'member') unless Role.where('name =?', 'member').count > 0
    Role.create(:name => 'visitor') unless Role.where('name =?', 'visitor').count > 0
  end

  def down
  end
end
