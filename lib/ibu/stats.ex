defmodule IBU.Stats do
  @moduledoc """
  """

  alias IBU.Stats.Standing, as: Stnd
  alias IBU.Stats.Percentage, as: Pcnt

  @standing_wc_attribute "WC"

  @doc """
  Build a map of statistics for an athletes given data from /CISBios?IBUId=

  The build use merge to merge different statistics together under one set of
  season_id keys. As long as the map getting merged in uses season_ids are key
  it will get merged in correctly.

  """
  @spec build(map) :: map
  def build(data) do
    stats = Pcnt.build(data)
    stand = Stnd.build(Map.keys(stats), Map.fetch!(data, @standing_wc_attribute))

    merge([stats, stand])
  end

  defp merge(list) when is_list(list) do
    {acc, list} = List.pop_at(list, 0)
    merge(list, acc)
  end

  defp merge([], acc), do: acc

  defp merge([h | t], acc) do
    accu_keys = acc |> Map.keys()
    head_keys = h |> Map.keys()

    missing_from_head = accu_keys -- head_keys
    missing_from_acc = head_keys -- accu_keys

    h = Enum.reduce(missing_from_head, h, fn key, inner_acc -> Map.put(inner_acc, key, %{}) end)

    acc =
      Enum.reduce(missing_from_acc, acc, fn key, inner_acc -> Map.put(inner_acc, key, %{}) end)

    data =
      Enum.reduce(h, %{}, fn {key, value}, inner_acc ->
        acc_value =
          case Map.get(acc, key) do
            nil -> %{}
            value -> value
          end

        updated = Map.merge(acc_value, value)
        Map.put(inner_acc, key, updated)
      end)

    merge(t, data)
  end
end
