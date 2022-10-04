defmodule ParseTest do
  use ExUnit.Case
  doctest IBU.Code
  alias IBU.Code

  @error {:error, :unknown_format, nil}

  test "athlete" do
    assert @error = Code.parse(nil)
    assert {:ok, :individual, data} = Code.parse("BTGER12403199001")

    assert %{
             country_code: "GER",
             gender: :male,
             birth_day: 24,
             birth_month: 03,
             birth_year: 1990,
             number: 1
           } = data
  end

  test "team" do
    assert @error = Code.parse(nil)
    assert {:error, :unknown_format, "BTGER8"} = Code.parse("BTGER8")

    assert {:ok, :team, data} = Code.parse("BTGER1")

    assert %{
             country_code: "GER",
             gender: :male
           } = data

    assert {:ok, :team, data} = Code.parse("BTROC9")

    assert %{
             country_code: "RUS",
             gender: :mixed
           } = data
  end

  test "race" do
    assert @error = Code.parse(nil)
    assert {:ok, :race, data} = Code.parse("BT1920SWRLCP07SMMS")

    assert %{
             season: 1920,
             level: :world_cup,
             race_number: 7,
             gender: :male,
             event: :mass_start
           } = data
  end

  test "competition" do
    assert @error = Code.parse(nil)
    assert {:ok, :competition, data} = Code.parse("BT1920SWRLCP02")

    assert %{
             season: 1920,
             level: :world_cup,
             competition_number: 2
           } = data
  end

  test "nation" do
    assert @error = Code.parse(nil)
    assert {:ok, :nation, %{country_code: "GER"}} = Code.parse("GER")
    assert {:ok, :nation, %{country_code: "MKD"}} = Code.parse("MKD_FYROM")
  end
end
