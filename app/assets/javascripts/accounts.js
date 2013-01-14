var Account, AccountsViewModel;

Account = function(id, slug, name) {
  var self = this;
  self.id = id;
  self.slug = slug;
  self.name = name;
};

AccountsViewModel = function() {
  var self = this;
  var accountNameField =$('#accountName');
  var accountSlugField =$('#accountSlug');
  var accountIdField =$('#accountId');

  self.accounts = ko.observableArray([]);
  this.addNewAccount = function() {
    var accountName = accountNameField.val();
    self.accounts.push(new Account(accountIdField.val(), accountSlugField.val(), accountName));
    accountNameField.val('');
  };
  this.removeAccount = function(account) {
    self.accounts.remove(account);
  };
  this.editAccount = function(account) {
    var accountName;
    accountName = accountNameField.val();
    account.name = accountName;
  };
  this.listAccounts = function() {
    $.getJSON("/accounts", function(acc) {
      $.map(acc, function(item) {
        var account = new Account(item.id, item.slug, item.name);
        self.accounts.push(account);
      });
    });
  };
  this.listAccounts();
};

$(function(){
  ko.applyBindings(new AccountsViewModel());
});
