defmodule Babygenius.Identity.HashidGenerator do
  @valid_alphabet "abcdefghijklmnopqrstuvwxyz1234567890"

  def decode(encoded) do
    get_spec()
    |> Hashids.decode(encoded)
  end

  def encode(unencoded) do
    get_spec()
    |> Hashids.encode(unencoded)
  end

  defp get_spec() do
    Hashids.new(
      # using a custom salt helps producing unique cipher text
      salt: Application.get_env(:babygenius, :hashids_salt),
      # minimum length of the cipher text (1 by default)
      min_len: 3,
      alphabet: @valid_alphabet
    )
  end
end