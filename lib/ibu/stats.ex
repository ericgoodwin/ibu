defmodule IBU.Stats do
  @moduledoc """
  """

  alias IBU.Stats.Standing, as: Stnd
  alias IBU.Stats.Percentage, as: Pcnt

  @doc """
  Build a map of statistics for an athletes given data from /CISBios?IBUId=

  The build use merge to merge different statistics together under one set of
  season_id keys. As long as the map getting merged in uses season_ids are key
  it will get merged in correctly.

  """
  @spec build(map) :: map
  def build(data) do
    stats_data =
      Map.take(data, [
        "StatSeasons",
        "StatShooting",
        "StatShootingProne",
        "StatShootingStanding",
        "StatSkiing"
      ])

    stand_data = Map.take(data, ["WC"])

    stats = Pcnt.build(stats_data)
    stand = Stnd.build(Map.keys(stats), Map.fetch!(stand_data, "WC"))

    merge([stats, stand])
  end

  def merge(list) when is_list(list) do
    {acc, list} = List.pop_at(list, 0)
    merge(list, acc)
  end

  def merge([], acc), do: acc

  def merge([h | t], acc) do
    merge(t, IBU.Utils.deep_merge(h, acc))
  end
end
