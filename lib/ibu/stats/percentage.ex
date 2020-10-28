defmodule IBU.Stats.Percentage do
  @moduledoc """
  """

  # If we don't have any stat season then do not bother trying to get
  # percentages for stats
  @spec build(map) :: map
  def build(%{"StatSeasons" => []}), do: %{}

  def build(data) do
    Range.new(0, Enum.count(data["StatSeasons"]) - 1)
    |> Enum.to_list()
    |> build_percentages(data)
  end

  @spec build_percentages([integer], any) :: any
  defp build_percentages(list, data), do: build_percentages(list, data, %{})

  @spec build_percentages([integer], any, any) :: any
  defp build_percentages([], _data, acc), do: acc

  defp build_percentages([index | t], data, acc) do
    season_id = get_stat(data, "StatSeasons", index)
    shooting = get_stat(data, "StatShooting", index)
    prone = get_stat(data, "StatShootingProne", index)
    standing = get_stat(data, "StatShootingStanding", index)
    skiing = get_stat(data, "StatSkiing", index)

    acc = Map.put_new(acc, season_id, %{})

    stats =
      Map.put(acc[season_id], :shooting_percentage, shooting)
      |> Map.put(:shooting_prone_percentage, prone)
      |> Map.put(:shooting_overall_percentage, shooting)
      |> Map.put(:shooting_stand_percentage, standing)
      |> Map.put(:skiing_speed_percentage, skiing)

    build_percentages(t, data, Map.put(acc, season_id, stats))
  end

  defp get_stat(data, key, index) when is_binary(key) do
    data
    |> Map.get(key)
    |> Enum.fetch!(index)
    |> to_string
    |> String.replace(~r/[^\d]/, "")
    |> String.split("/")
    |> Enum.join()
    |> IBU.Utils.try_integer()
  end
end
