defmodule Babygenius.FetchTimezoneData do
  def perform(fetch_api \\ HTTPoison.get!/1)
    fetch_api.("some_url")
  end
end
