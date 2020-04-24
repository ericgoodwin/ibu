defmodule ParseTest do
  use ExUnit.Case
  doctest IBU.Code
  alias IBU.Code

  @error {:error, :unknown_format}

  test "athlete" do
    assert @error = Code.parse(nil)
    assert {:individual, data} = Code.parse("BTGER12403199001")

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
    assert @error = Code.parse(nil)
    assert @error = Code.parse("BTGER8")
    assert {:team, data} = Code.parse("BTGER1")

    assert [
             {:country_code, "GER"},
             {:gender, :male}
           ] = data
  end

  test "race" do
    assert @error = Code.parse(nil)
    assert {:race, data} = Code.parse("BT1920SWRLCP07SMMS")

    assert [
             {:season, 1920},
             {:level, :world_cup},
             {:world_cup_number, 7},
             {:gender, :male},
             {:event, :mass_start}
           ] = data
  end

  test "competition" do
    assert @error = Code.parse(nil)
    assert {:competition, data} = Code.parse("BT1920SWRLCP02")

    assert [
             {:season, 1920},
             {:level, :world_cup},
             {:world_cup_number, 2}
           ] = data
  end
end
