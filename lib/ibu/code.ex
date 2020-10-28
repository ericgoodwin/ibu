defmodule IBU.Code do
  @spec parse(binary) :: {atom, map}

  def parse(
        <<66, 84, season::binary-size(4), 83, level::binary-size(5), 95, 95,
          gender::binary-size(2), event::binary-size(2)>>
      ) do
    {:ok, :cup,
     %{
       season: String.to_integer(season),
       gender: parse_gender(gender),
       event: parse_event_code(event),
       level: parse_level(level)
     }}
  end

  def parse(<<66, 84, country_code::binary-size(3), gender::binary-size(1)>>)
      when gender in ["1", "2", "9"] do
    {:ok, :team, %{country_code: country_code, gender: parse_gender(gender)}}
  end

  def parse(
        <<66, 84, country_code::binary-size(3), gender::binary-size(1), birth_day::binary-size(2),
          birth_month::binary-size(2), birth_year::binary-size(4), number::binary-size(2)>>
      )
      when gender in ["1", "2"] do
    {:ok, :individual,
     %{
       country_code: country_code,
       gender: parse_gender(gender),
       birth_day: String.to_integer(birth_day),
       birth_month: String.to_integer(birth_month),
       birth_year: String.to_integer(birth_year),
       number: String.to_integer(number)
     }}
  end

  def parse(
        <<66, 84, season::binary-size(4), 83, level::binary-size(5), race_number::binary-size(2),
          gender::binary-size(2), event::binary-size(2)>>
      )
      when gender in ["SM", "SW", "MX"] and level in ["WRLCP", "WRLCH", "WRLOG"] do
    {:ok, :race,
     %{
       season: String.to_integer(season),
       level: parse_level(level),
       race_number: parse_race_number(race_number),
       gender: parse_gender(gender),
       event: parse_event_code(event)
     }}
  end

  def parse(
        <<66, 84, season::binary-size(4), 83, level::binary-size(5),
          competition_number::binary-size(2)>>
      )
      when level in ["WRLCP", "WRLCH", "WRLOG"] do
    {:ok, :competition,
     %{
       season: String.to_integer(season),
       level: parse_level(level),
       competition_number: parse_race_number(competition_number)
     }}
  end

  def parse(<<country_code::binary-size(3)>>) do
    {:ok, :nation, %{country_code: country_code, gender: :mixed}}
  end

  def parse("MKD_FYROM") do
    {:ok, :nation, %{country_code: "MKD", gender: :mixed}}
  end

  def parse(str), do: {:error, :unknown_format, str}

  @spec parse_gender(binary) :: atom
  defp parse_gender("SM"), do: :male
  defp parse_gender("SW"), do: :female
  defp parse_gender("MX"), do: :mixed
  defp parse_gender("1"), do: :male
  defp parse_gender("2"), do: :female
  defp parse_gender("9"), do: :mixed

  @spec parse_level(binary) :: atom
  defp parse_level("WRLCH"), do: :world_championship
  defp parse_level("WRLCP"), do: :world_cup
  defp parse_level("WRLOG"), do: :olympics

  @spec parse_event_code(binary) :: atom
  defp parse_event_code("MS"), do: :mass_start
  defp parse_event_code("RL"), do: :relay
  defp parse_event_code("PU"), do: :pursuit
  defp parse_event_code("SR"), do: :single_relay
  defp parse_event_code("SP"), do: :sprint
  defp parse_event_code("IN"), do: :individual
  defp parse_event_code("NC"), do: :nations
  defp parse_event_code("TS"), do: :overall

  @spec parse_race_number(binary) :: atom
  defp parse_race_number("__"), do: nil
  defp parse_race_number(string), do: String.to_integer(string)
end
