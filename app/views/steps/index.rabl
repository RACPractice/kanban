collection :@steps
attributes :id, :name, :removable, :capacity, :category
child(:work_items) do
	attributes :id, :name, :description, :position, :assigned_to, :step_id, :work_value, :label_list
	child(:users) do
		attributes membership_id: :id, id: :user_id, username: :username, avatar_src: :avatar_src
	end
	child(:tasks) do
		attributes id: :id, name: :name, done: :done, work_item_id: :work_item_id
	end
end
