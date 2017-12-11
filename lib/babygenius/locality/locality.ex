defmodule Babygenius.Locality do
  @moduledoc """
  The Locality context. This manages concerns around a user's location, and their
  associated implications around time zones.
  """

  import Ecto.Query, warn: false

  alias Babygenius.Locality.Zipcode

  @zipcode_timezone_service Application.get_env(:babygenius, :zipcode_timezone_service)

  @doc """
  Returns the list of zipcodes.

  ## Examples

      iex> list_zipcodes()
      [%Zipcode{}, ...]

  """
  @spec list_zipcodes() :: [%Zipcode{}]
  def list_zipcodes do
    [%Zipcode{zip: "94606", timezone: "America/Los_Angeles"}]
  end

  @doc """
  Gets a single zipcode.

  Raises if the Zipcode does not exist.

  ## Examples

      iex> get_zipcode!(123)
      %Zipcode{}

  """
  @spec get_zipcode!(zip :: String.t()) :: %Zipcode{} | nil
  def get_zipcode!(zip) do
    @zipcode_timezone_service.fetch_zipcode(zip)
  end

  @spec create_zipcode(attrs :: map()) :: {:ok, %Zipcode{}}
  def create_zipcode(attrs) do
    {:ok, struct(Zipcode, attrs)}
  end
end