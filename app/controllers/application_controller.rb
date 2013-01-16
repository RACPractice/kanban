class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :loadAccounts

	#Handle the CANCAN exception
	rescue_from CanCan::AccessDenied do |exception|
		flash[:error] = exception.message
		redirect_to root_url
	end

  private
  #
  # If user logged in load all accounts for accounts dropdown select
  # * *Returns* :
  #   - nothing
  def loadAccounts
    @accounts = []
    if current_user
      @accounts = Account.all_available(current_user)
    end
  end
end
