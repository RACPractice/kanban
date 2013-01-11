Account = (name) ->
  @name = name
  self

AccountsViewModel = () ->
  self = this
  self.accounts = ko.observableArray([])
  @addNewAccount = () =>
    accountName = $('#accountName').val()
    self.accounts.push(new Account('accountName'))
  @removeAccount = (account) =>
    self.accounts.remove(account)
  @editAccount = (account) =>
    accountName = $('#accountName').val()
    account.name = accountName
  @listAccounts = () =>
    $.getJSON("/accounts", (accounts) =>
        $.map(accounts, (item) ->
          acc = new Account(item.name)
          self.accounts.push(acc)
        )
    )
  @listAccounts()

ko.applyBindings(new AccountsViewModel())