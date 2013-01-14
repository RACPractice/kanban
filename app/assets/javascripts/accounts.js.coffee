class Account
  constructor: (@id, @slug, @name) ->

class AccountsViewModel
  constructor: ->
    @accountNameField = $('#accountName')
    @accountSlugField =$('#accountSlug')
    @accountIdField =$('#accountId')
    @accounts = ko.observableArray []
    @listAccounts()

  addNewAccount:  =>
    accountName = @accountNameField.val()
    @accounts.push(new Account(@accountIdField.val(), @accountSlugField.val(), accountName))
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
