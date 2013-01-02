class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.string :slug
      t.string :description
      t.references :account
      t.string :visible
      t.timestamps
    end

    add_index :projects, :account_id
  end
end
