# lib/bank_api/accounts/projectors/account_opened.ex

defmodule BankAPI.Accounts.Projectors.AccountOpened do
  use Commanded.Projections.Ecto,
  application: BankAPI.CommandedApp,
  repo: BankAPI.Repo,
    name: "Accounts.Projectors.AccountOpened"

  alias BankAPI.Accounts.Events.AccountOpened
  alias BankAPI.Accounts.Projections.Account

  project(%AccountOpened{} = evt, _metadata, fn multi ->
    Ecto.Multi.insert(multi, :account_opened, %Account{
      uuid: evt.account_uuid,
      current_balance: evt.initial_balance,
      status: Account.status().open
    })
  end)
end
