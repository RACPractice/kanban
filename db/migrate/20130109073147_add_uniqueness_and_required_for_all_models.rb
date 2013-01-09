class AddUniquenessAndRequiredForAllModels < ActiveRecord::Migration
  def up
    #projects
    add_index :projects, :slug, :unique => true

    #accounts
    change_column :accounts, :name, :string, :null => false
    change_column :accounts, :slug, :string, :null => false
    add_index :accounts, :name
    add_index :accounts, :slug, :unique => true

    #priorities
    change_column :priorities, :name, :string, :null => false
    change_column :priorities, :slug, :string, :null => false
    add_index :priorities, :name
    add_index :priorities, :slug, :unique => true

    #steps
    change_column :steps, :name, :string, :null => false
    change_column :steps, :slug, :string, :null => false
    add_index :steps, :name
    add_index :steps, :slug, :unique => true

    #tasks
    change_column :tasks, :name, :string, :null => false
    change_column :tasks, :slug, :string, :null => false
    add_index :tasks, :name
    add_index :tasks, :slug, :unique => true

    #work_items
    change_column :work_items, :name, :string, :null => false
    change_column :work_items, :slug, :string, :null => false
    add_index :work_items, :name
    add_index :work_items, :slug, :unique => true

    #work_types
    change_column :work_types, :name, :string, :null => false
    change_column :work_types, :slug, :string, :null => false
    add_index :work_types, :name
    add_index :work_types, :slug, :unique => true
  end

  def down
    #projects
    remove_index :projects, :slug

    #accounts
    change_column :accounts, :name, :string
    change_column :accounts, :slug, :string
    remove_index :accounts, :name
    remove_index :accounts, :slug

    #priorities
    change_column :accounts, :name, :string
    change_column :accounts, :slug, :string
    remove_index :accounts, :name
    remove_index :accounts, :slug

    #steps
    change_column :steps, :name, :string
    change_column :steps, :slug, :string
    remove_index :steps, :name
    remove_index :steps, :slug

    #tasks
    change_column :tasks, :name, :string
    change_column :tasks, :slug, :string
    remove_index :tasks, :name
    remove_index :tasks, :slug

    #work_items
    change_column :work_items, :name, :string
    change_column :work_items, :slug, :string
    remove_index :work_items, :name
    remove_index :work_items, :slug

    #work_types
    change_column :work_types, :name, :string
    change_column :work_types, :slug, :string
    remove_index :work_types, :name
    remove_index :work_types, :slug
  end
end
