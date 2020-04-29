defmodule IBU.Stats.Percentage do
  @moduledoc """
  """

  @spec build(map) :: map
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
      |> Map.put(:prone_shoot_percentage, prone)
      |> Map.put(:overall_shoot_percentage, shooting)
      |> Map.put(:standing_shoot_percentage, standing)
      |> Map.put(:skiing_percentage, skiing)

    build_percentages(t, data, Map.put(acc, season_id, stats))
  end

  defp get_stat(data, binary, index) when is_binary(binary) do
    data
    |> Map.get("StatSeasons")
    |> Enum.fetch!(index)
    |> String.split("/")
    |> Enum.join()
    |> String.to_integer()
  end
end
