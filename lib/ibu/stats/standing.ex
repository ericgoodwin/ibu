defmodule IBU.Stats.Standing do
  @moduledoc """
  """

  @spec build(list, map) :: map
  def build(seasons, data) do
    seasons
    |> Enum.map(&season_id_key_mapping/1)
    |> build_standings(data, %{})
  end

  @spec build_standings([{any, any}], any, any) :: any
  defp build_standings([], _data, acc), do: acc

  defp build_standings([{season_id, ibu_key} | t], data, acc) do
    season =
      data
      |> Enum.find(fn x -> Map.get(x, "Year") == ibu_key end)

    standings = %{
      individual_standings: season |> get_standing("Ind"),
      sprint_standings: season |> get_standing("Spr"),
      pursuit_standings: season |> get_standing("Pur"),
      mass_start_standings: season |> get_standing("Mas"),
      overall_standings: season |> get_standing("Tot")
    }

    acc = Map.put(acc, season_id, standings)

    build_standings(t, data, acc)
  end

  defp get_standing(standings, category) do
    standings
    |> Map.fetch!(category)
    |> String.replace(~r/[^\d]/, "")
    |> String.to_integer()
  end

  defp season_id_key_mapping(season_id) do
    ibu_key =
      season_id
      |> Integer.to_string()
      |> String.split_at(2)
      |> Tuple.to_list()
      |> Enum.join("/")

    {season_id, ibu_key}
  end
end
