class HomeController < ApplicationController

	before_filter :authenticate_user!

  def index
    @owner_accounts = Account.all_where_owner current_user
    @member_accounts = Account.all_where_member current_user
    @visitor_accounts = Account.all_where_visitor current_user
	end
end
