defmodule IBUTest do
  use ExUnit.Case

  # doctest IBU

  setup do
    # Using `mock_global` instead of `mock` due to a bug where Telsa.Middleware.Timeout
    # will cause it to run in a different process and we won't find the mock
    # See: https://github.com/teamon/tesla/issues/157
    Tesla.Mock.mock_global(fn
      %{
        method: :get,
        url:
          "https://biathlonresults.com/modules/sportapi/api/Athletes?FamilyName=fourcade&GivenName="
      } ->
        %Tesla.Env{
          status: 200,
          body: %{
            "Athletes" => [
              %{
                "Age" => 31,
                "Birthdate" => "1988-09-14T00:00:00",
                "FamilyName" => "FOURCADE",
                "Functions" => "Athlete",
                "GenderId" => "M",
                "GivenName" => "Martin",
                "IBUId" => "BTFRA11409198801",
                "NAT" => "FRA",
                "NF" => "FRA",
                "otherFamilyNames" => nil,
                "otherGivenNames" => nil,
                "StatSeasons" => [],
                "StatShooting" => [],
                "StatShootingProne" => [],
                "StatShootingStanding" => [],
                "StatSkiing" => [],
                "WC" => []
              },
              %{
                "Age" => 35,
                "Birthdate" => "1984-04-25T00:00:00",
                "FamilyName" => "FOURCADE",
                "Functions" => "Official",
                "GenderId" => "M",
                "GivenName" => "Simon",
                "IBUId" => "BTFRA12504198401",
                "NAT" => "FRA",
                "NF" => "FRA",
                "otherFamilyNames" => nil,
                "otherGivenNames" => nil,
                "StatSeasons" => [],
                "StatShooting" => [],
                "StatShootingProne" => [],
                "StatShootingStanding" => [],
                "StatSkiing" => [],
                "WC" => []
              }
            ]
          }
        }
    end)

    :ok
  end

  test "search_athletes" do
    response = IBU.search_athletes("fourcade")

    assert {:ok,
            [
              %IBU.Athlete{
                birth_date: ~D[1988-09-14],
                country_code: "FRA",
                family_name: "FOURCADE",
                flag_uri: nil,
                gender: "M",
                given_name: "Martin",
                ibu_id: "BTFRA11409198801",
                photo_uri: nil
              }
            ]} = response
  end
end
