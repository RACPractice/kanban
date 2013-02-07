class RenameTypeToCategory < ActiveRecord::Migration
  def up
  	rename_column :steps, :type, :category
  end

  def down
  	rename_column :steps, :category, :type
  end
end
