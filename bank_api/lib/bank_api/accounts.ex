# lib/bank_api/accounts.ex

defmodule BankAPI.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false

  alias Ecto.Changeset
  alias BankAPI.Repo
  alias BankAPI.Router
  alias BankAPI.Accounts.Commands.{OpenAccount, CloseAccount}
  alias BankAPI.Accounts.Projections.Account

  def uuid_regex do
    ~r/[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/
  end

  def get_account(id) do
    case Repo.get(Account, id) do
      %Account{} = account ->
        {:ok, account}

      _reply ->
        {:error, :not_found}
    end
  end

  def close_account(id) do
    %CloseAccount{
      account_uuid: id
    }
    |> BankAPI.CommandedApp.dispatch()
  end

  def open_account(%{"initial_balance" => initial_balance}) do

    account_uuid = UUID.uuid4()

    dispatch_result =
      %OpenAccount{
        initial_balance: initial_balance,
        account_uuid: account_uuid
      }
      |> BankAPI.CommandedApp.dispatch()

    case dispatch_result do
      :ok ->
        {
          :ok,
          %Account{
            uuid: account_uuid,
            current_balance: initial_balance
          }
        }

      reply ->
        reply
    end
  end

  defp account_opening_changeset(params) do
    {
      params,
      %{initial_balance: :integer}
    }
    |> Changeset.cast(params, [:initial_balance])
    |> Changeset.validate_required([:initial_balance])
    |> Changeset.validate_number(:initial_balance, greater_than: 0)
  end
end
