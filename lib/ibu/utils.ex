defmodule IBU.Utils do
  @doc """
  Merge one map into another going deeper than just one level

  ## Examples

    iex> IBU.Utils.deep_merge(%{1920 => %{five: "five"}, 2021 => %{six: "six"}}, %{1819 => %{three: "three"}, 1920 => %{four: "four"}})
    %{ 1819 => %{three: "three"}, 1920 => %{five: "five", four: "four"}, 2021 => %{six: "six"}

  """
  @spec deep_merge(map, map) :: map
  def deep_merge(left, right) do
    Map.merge(left, right, &deep_resolve/3)
  end

  # Key exists in both maps, and both values are maps as well.
  # These can be merged recursively.
  defp deep_resolve(_key, left = %{}, right = %{}) do
    deep_merge(left, right)
  end

  # Key exists in both maps, but at least one of the values is
  # NOT a map. We fall back to standard merge behavior, preferring
  # the value on the right.
  defp deep_resolve(_key, _left, right) do
    right
  end

  @spec try_integer(<<>>) :: nil | integer
  def try_integer(""), do: nil
  def try_integer(num), do: String.to_integer(num)
end
