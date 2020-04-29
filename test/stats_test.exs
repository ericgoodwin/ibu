defmodule StatsTest do
  use ExUnit.Case

  test "merge with one item" do
    map_one = %{1819 => %{one: "one", two: "two"}}
    map_two = %{1819 => %{three: "three"}, 1920 => %{four: "four"}}

    response = IBU.Stats.merge([map_one])

    assert %{1819 => %{one: "one", two: "two"}} = response
  end

  test "merge with two items" do
    map_one = %{1819 => %{one: "one", two: "two"}}
    map_two = %{1819 => %{three: "three"}, 1920 => %{four: "four"}}

    response = IBU.Stats.merge([map_one, map_two])

    assert %{1819 => %{one: "one", two: "two", three: "three"}, 1920 => %{four: "four"}} =
             response
  end

  test "merge with three items" do
    map_one = %{1819 => %{one: "one", two: "two"}}
    map_two = %{1819 => %{three: "three"}, 1920 => %{four: "four"}}
    map_three = %{1920 => %{five: "five"}, 2021 => %{six: "six"}}

    response = IBU.Stats.merge([map_one, map_two, map_three])

    assert %{
             1819 => %{one: "one", two: "two", three: "three"},
             1920 => %{four: "four", five: "five"},
             2021 => %{six: "six"}
           } = response
  end
end
