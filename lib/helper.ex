defmodule Ibu.Helper do

  @spec to_birth_date(nil) :: nil
  def to_birth_date(nil), do: nil

  @spec to_birth_date(binary) :: Date.t()
  def to_birth_date(str) when is_binary(str) do
    {:ok, birth_date, _offset} = DateTime.from_iso8601(str <> "Z")
    birth_date |> DateTime.to_date()
  end

  @spec to_date_time(binary) :: DateTime.t()
  def to_date_time(str) do
    {:ok, parsed_date, _offset} = DateTime.from_iso8601(str)
    parsed_date
  end
end
