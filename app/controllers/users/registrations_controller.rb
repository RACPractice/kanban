class Users::RegistrationsController < Devise::RegistrationsController

	def new
		resource = build_resource({})
		accounts = resource.accounts.build
	end

end
