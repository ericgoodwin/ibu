defmodule ParseTest do
  use ExUnit.Case
  doctest Ibu.Codes.Parse
  alias Ibu.Codes.Parse

  @error {:error, :unknown_format}

  test "athlete" do
    assert @error = Parse.ibu_id(nil)
    assert {:individual, data} = Parse.ibu_id("BTGER12403199001")

    assert [
             {:country_code, "GER"},
             {:gender, :male},
             {:birth_day, 24},
             {:birth_month, 03},
             {:birth_year, 1990},
             {:number, 1}
           ] = data
  end

  test "team" do
    assert @error = Parse.ibu_id(nil)
    assert @error = Parse.ibu_id("BTGER8")
    assert {:team, data} = Parse.ibu_id("BTGER1")

    assert [
             {:country_code, "GER"},
             {:gender, :male}
           ] = data
  end

  test "race" do
    assert @error = Parse.ibu_id(nil)
    assert {:race, data} = Parse.ibu_id("BT1920SWRLCP07SMMS")

    assert [
             {:season, "1920"},
             {:level, :world_cup},
             {:world_cup_number, 7},
             {:gender, :male},
             {:event, :mass_start}
           ] = data
  end

  test "competition" do
    assert @error = Parse.ibu_id(nil)
    assert {:competition, data} = Parse.ibu_id("BT1920SWRLCP02")

    assert [
             {:season, "1920"},
             {:level, :world_cup},
             {:world_cup_number, 2}
           ] = data
  end
end
