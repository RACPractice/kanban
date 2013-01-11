class AddDefaultRolesInDb < ActiveRecord::Migration
  def up
    Role.create(:name => 'owner') if Role.where('name =?', 'owner').count > 0
    Role.create(:name => 'member') if Role.where('name =?', 'member').count > 0
    Role.create(:name => 'visitor') if Role.where('name =?', 'visitor').count > 0
  end

  def down
  end
end
