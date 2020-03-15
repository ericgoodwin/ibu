defmodule Ibu.Helper do
  def to_birth_date(str) do
    {:ok, birth_date, _offset} = DateTime.from_iso8601(str <> "Z")
    birth_date |> DateTime.to_date()
  end

  def to_date_time(str) do
    {:ok, parsed_date, _offset} = DateTime.from_iso8601(str)
    parsed_date
  end
end
