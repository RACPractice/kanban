class CreatePriorities < ActiveRecord::Migration
  def change
    create_table :priorities do |t|
     t.string :name
     t.string :slug
      t.timestamps
    end
  end
end
