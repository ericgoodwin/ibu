defmodule IBU.AthleteTest do
  use ExUnit.Case, async: true

  alias IBU.Athlete

  defp build(functions) do
    Athlete.build_from_api(%{
      "FamilyName" => "BOE",
      "GivenName" => "Test",
      "Birthdate" => "1998-07-11T00:00:00",
      "Functions" => functions,
      "GenderId" => "M",
      "IBUId" => "BTNOR11807199801",
      "NAT" => "NOR",
      "StatSeasons" => [],
      "StatShooting" => [],
      "StatShootingProne" => [],
      "StatShootingStanding" => [],
      "StatSkiing" => [],
      "WC" => []
    })
  end

  test "maps known functions to a status" do
    assert build("Athlete").status == "athlete"
    assert build("Athlete, Official").status == "athlete"
    assert build("Not active").status == "inactive"
    assert build("Official").status == "official"
    assert build(nil).status == nil
  end

  test "maps Deceased to deceased" do
    assert build("Deceased").status == "deceased"
  end

  test "unknown functions do not crash and yield a nil status" do
    assert build("Something New").status == nil
  end
end
