defmodule Ibu.DateHelper do
  @spec to_birth_date(nil) :: nil
  def to_birth_date(nil), do: nil

  @spec to_birth_date(binary) :: Date.t()
  def to_birth_date(str) when is_binary(str) do
    {:ok, birth_date, _offset} =
      str
      |> fix_incorrect_datetime_format
      |> transform_date_format_to_datetime
      |> DateTime.from_iso8601()

    birth_date |> DateTime.to_date()
  end

  @spec to_date_time(nil) :: nil
  def to_date_time(nil), do: nil

  @spec to_date_time(binary) :: DateTime.t()
  def to_date_time(str) do
    {:ok, parsed_date, _offset} = DateTime.from_iso8601(str)
    parsed_date
  end

  @spec fix_incorrect_datetime_format(binary) :: binary
  defp fix_incorrect_datetime_format(str) do
    case Regex.match?(~r/^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}$/, str) do
      true -> str <> "Z"
      false -> str
    end
  end

  @spec transform_date_format_to_datetime(binary) :: binary
  defp transform_date_format_to_datetime(str) do
    case Regex.match?(~r/^\d{4}-\d{2}-\d{2}$/, str) do
      true -> str <> "T00:00:00Z"
      false -> str
    end
  end
end
