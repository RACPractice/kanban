class ChangeToRequiredNameAndSlugInProjects < ActiveRecord::Migration
  def up
    change_column :projects, :name, :string, :null => false
    change_column :projects, :slug, :string, :null => false
  end

  def down
    change_column :projects, :name, :string
    change_column :projects, :slug, :string
  end
end
