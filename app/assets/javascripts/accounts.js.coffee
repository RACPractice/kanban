class Account
  constructor: (@id, @slug, @name) ->
    @projects_url = "accounts/#{@id}/projects"

class AccountsViewModel
  constructor: ->
    @accountNameField = $('#accountName')
    @accountSlugField =$('#accountSlug')
    @accountIdField =$('#accountId')
    @accounts = ko.observableArray []
    @listAccounts()

  addNewAccount: =>
    accountName = @accountNameField.val()
    #save the new account
    $.post '/accounts.json', account: {name: accountName}, (resp) =>
      @accounts.push new Account(resp.id, resp.slug, resp.name)
    @accountNameField.val('')

  removeAccount: (account) =>
    @accounts.remove(account)

  editAccount: (account) =>
    account.name = @accountNameField.val()

  listAccounts: =>
    $.getJSON "/accounts", (acc) =>
      $.map acc, (item) =>
        @accounts.push new Account(item.id, item.slug, item.name)

$ ->
  ko.applyBindings new AccountsViewModel()
