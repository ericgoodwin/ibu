defmodule Ibu.Parse do
  @spec ibu_id(binary) :: {atom, keyword}
  def ibu_id(<<66, 84, country_code::binary-size(3), gender::binary-size(1)>>)
      when gender in ["1", "2", "9"] do
    {:team, [country_code: country_code, gender: parse_gender(gender)]}
  end

  def ibu_id(
        <<66, 84, country_code::binary-size(3), gender::binary-size(1), birth_day::binary-size(2),
          birth_month::binary-size(2), birth_year::binary-size(4), number::binary-size(2)>>
      )
      when gender in ["1", "2"] do
    {:individual,
     [
       country_code: country_code,
       gender: parse_gender(gender),
       birth_day: String.to_integer(birth_day),
       birth_month: String.to_integer(birth_month),
       birth_year: String.to_integer(birth_year),
       number: String.to_integer(number)
     ]}
  end

  def ibu_id(
        <<66, 84, season::binary-size(4), 83, level::binary-size(5), world_cup_number::binary-size(2),
          gender::binary-size(2), event::binary-size(2)>>
      )
      when gender in ["SM", "SW", "MX"] and level in ["WRLCP", "WRLCH"] do
    {:race,
     [
       season: season,
       level: level,
       world_cup_number: parse_world_cup_number(world_cup_number),
       gender: parse_gender(gender),
       event: parse_event_code(event)
     ]}
  end

  def ibu_id(_), do: {:error, :unknown_format}

  @spec parse_gender(binary) :: atom
  defp parse_gender("SM"), do: :male
  defp parse_gender("SW"), do: :female
  defp parse_gender("MX"), do: :mixed
  defp parse_gender("1"), do: :male
  defp parse_gender("2"), do: :female
  defp parse_gender("9"), do: :mixed

  defp parse_event_code("MS"), do: :mass_start
  defp parse_event_code("RL"), do: :relay
  defp parse_event_code("PU"), do: :pursuit
  defp parse_event_code("SR"), do: :single_relay
  defp parse_event_code("SP"), do: :sprint
  defp parse_event_code("IN"), do: :individual

  defp parse_world_cup_number("__"), do: nil
  defp parse_world_cup_number(string), do: String.to_integer(string)
end
