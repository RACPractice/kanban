class CreateSteps < ActiveRecord::Migration
  def change
    create_table :steps do |t|
      t.string :name
      t.string :slug
      t.boolean :anchor
      t.integer :capacity
      t.integer :position
      t.timestamps
    end
  end
end
