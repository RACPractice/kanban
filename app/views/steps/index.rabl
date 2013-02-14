collection :@steps
attributes :id, :name, :removable, :capacity, :category
child(:work_items) do
	attributes :id, :name, :description, :position, :assigned_to, :step_id, :work_value
	child(:users) do
		attributes membership_id: :id, id: :user_id, username: :username, avatar_src: :avatar_src
	end
end
