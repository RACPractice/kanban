# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130115152534) do

  create_table "accounts", :force => true do |t|
    t.string   "name",        :null => false
    t.string   "slug",        :null => false
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "accounts", ["name"], :name => "index_accounts_on_name"
  add_index "accounts", ["slug"], :name => "index_accounts_on_slug", :unique => true

  create_table "members", :force => true do |t|
    t.integer  "user_id"
    t.integer  "account_id"
    t.boolean  "invite_sent", :default => false, :null => false
    t.boolean  "member",      :default => false, :null => false
    t.boolean  "owner",       :default => false, :null => false
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.integer  "role_id"
  end

  add_index "members", ["role_id"], :name => "index_members_on_role_id"
  add_index "members", ["user_id", "account_id"], :name => "index_members_on_user_id_and_account_id"

  create_table "memberships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "account_id"
    t.boolean  "invite_sent", :default => false, :null => false
    t.boolean  "member",      :default => false, :null => false
    t.boolean  "owner",       :default => false, :null => false
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  add_index "memberships", ["user_id", "account_id"], :name => "index_memberships_on_user_id_and_account_id"

  create_table "priorities", :force => true do |t|
    t.string   "name",       :null => false
    t.string   "slug",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "priorities", ["name"], :name => "index_priorities_on_name", :unique => true
  add_index "priorities", ["slug"], :name => "index_priorities_on_slug", :unique => true

  create_table "projects", :force => true do |t|
    t.string   "name",                           :null => false
    t.string   "slug",                           :null => false
    t.string   "description"
    t.integer  "account_id"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.boolean  "visible",     :default => false, :null => false
  end

  add_index "projects", ["account_id"], :name => "index_projects_on_account_id"
  add_index "projects", ["slug"], :name => "index_projects_on_slug", :unique => true

  create_table "projects_steps", :force => true do |t|
    t.integer "project_id"
    t.integer "step_id"
  end

  add_index "projects_steps", ["project_id", "step_id"], :name => "index_projects_steps_on_project_id_and_step_id"

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "roles", ["name"], :name => "index_roles_on_name"

  create_table "steps", :force => true do |t|
    t.string   "name",                         :null => false
    t.string   "slug",                         :null => false
    t.boolean  "anchor"
    t.integer  "capacity"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "removable",  :default => true, :null => false
  end

  add_index "steps", ["name"], :name => "index_steps_on_name"
  add_index "steps", ["slug"], :name => "index_steps_on_slug", :unique => true

  create_table "tasks", :force => true do |t|
    t.string   "name",                            :null => false
    t.string   "slug",                            :null => false
    t.text     "description"
    t.integer  "work_item_id",                    :null => false
    t.boolean  "is_completed", :default => false, :null => false
    t.date     "completed_at"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  add_index "tasks", ["is_completed"], :name => "index_tasks_on_is_completed"
  add_index "tasks", ["name"], :name => "index_tasks_on_name"
  add_index "tasks", ["slug"], :name => "index_tasks_on_slug", :unique => true
  add_index "tasks", ["work_item_id"], :name => "index_tasks_on_work_item_id"

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "username"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["username"], :name => "index_users_on_username"

  create_table "users_accounts", :force => true do |t|
    t.integer  "user_id"
    t.integer  "account_id"
    t.boolean  "is_invite_sent", :default => false, :null => false
    t.boolean  "is_member",      :default => false, :null => false
    t.boolean  "is_owner",       :default => false, :null => false
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  add_index "users_accounts", ["user_id", "account_id"], :name => "index_users_accounts_on_user_id_and_account_id"

  create_table "work_items", :force => true do |t|
    t.string   "name",                               :null => false
    t.string   "slug",                               :null => false
    t.text     "description"
    t.integer  "work_type_id"
    t.integer  "priority_id"
    t.integer  "work_value"
    t.integer  "position"
    t.boolean  "is_ready"
    t.boolean  "is_blocked",      :default => false, :null => false
    t.integer  "requested_by"
    t.integer  "assigned_to"
    t.date     "target_date"
    t.date     "completion_date"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.integer  "step_id",                            :null => false
  end

  add_index "work_items", ["name"], :name => "index_work_items_on_name"
  add_index "work_items", ["priority_id"], :name => "index_work_items_on_priority_id"
  add_index "work_items", ["slug"], :name => "index_work_items_on_slug", :unique => true
  add_index "work_items", ["step_id"], :name => "index_work_items_on_step_id"
  add_index "work_items", ["work_type_id"], :name => "index_work_items_on_work_type_id"

  create_table "work_types", :force => true do |t|
    t.string   "name",       :null => false
    t.string   "slug",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "work_types", ["name"], :name => "index_work_types_on_name"
  add_index "work_types", ["slug"], :name => "index_work_types_on_slug", :unique => true

end
