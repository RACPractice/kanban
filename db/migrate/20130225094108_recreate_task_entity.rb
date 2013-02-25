class RecreateTaskEntity < ActiveRecord::Migration
  def up
  	drop_table :tasks
  	create_table :tasks do |t|
      t.references :work_item, :null => false
      t.string :name, :null => false
      t.boolean :done, :null => false, :default => false
      t.timestamps
    end
  end

  def down
  end
end
