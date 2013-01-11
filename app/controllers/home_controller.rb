class HomeController < ApplicationController

	before_filter :authenticate_user!

  def index
    # @my_accounts = user.UsersAccounts.map{|a| a.}
    @member_accounts = user.accounts
	end

end
