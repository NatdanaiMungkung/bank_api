defmodule BankAPI.CommandedApp do
  use Commanded.Application,
    otp_app: :bank_api,
    event_store: [
      adapter: Commanded.EventStore.Adapters.EventStore,
      event_store: BankAPI.EventStore
    ]

  # router(BankAPI.CommandedRouter)
end