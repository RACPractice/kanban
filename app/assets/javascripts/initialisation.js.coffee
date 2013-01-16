$ ->
  accountSelect = $('#accounts')
  if ACCOUNT_ID
    accountSelect.show()
    accountSelect = $('#accounts')
    accountSelect.val(ACCOUNT_ID)
    accountSelect.change (value) ->
      window.location = "/accounts/#{this.value}/projects"
  else
    accountSelect.hide()