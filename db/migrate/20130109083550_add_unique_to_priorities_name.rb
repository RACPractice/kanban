class AddUniqueToPrioritiesName < ActiveRecord::Migration
  def up
    remove_index :priorities, :name
    add_index :priorities, :name, :unique => true
  end

  def down
    remove_index :priorities, :name
    add_index :priorities, :name
  end
end
