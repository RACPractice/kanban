class AddProfileFieldsToUser < ActiveRecord::Migration
  def change
    add_column :users, :full_name, :text
    add_attachment :users, :avatar
  end
end
