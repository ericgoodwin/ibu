defmodule Ibu.Result do
  @enforce_keys [:order, :athlete_ibu_id, :race_ibu_id, :country_code]
  defstruct([:order, :athlete_ibu_id, :race_ibu_id, :country_code])

  @type t :: %__MODULE__{
          order: integer,
          athlete_ibu_id: binary,
          race_ibu_id: binary,
          country_code: binary
        }

  @spec build_from_api(map, binary) :: t
  def build_from_api(data, race_id) when is_map(data) do
    %__MODULE__{
      order: data["ResultOrder"],
      athlete_ibu_id: data["IBUId"],
      country_code: data["Nat"],
      race_ibu_id: race_id
    }
  end
end

# %{
# "Behind" => "+9:05.9",
# "Bib" => "88",
# "BibColor" => nil,
# "IBUId" => "BTCHN21512199501",
# "IRM" => nil,
# "Leg" => nil,
# "LegRank" => nil,
# "NC" => "41",
# "NOC" => nil,
# "Name" => "ZHANG Zhaohan",
# "Nat" => "CHN",
# "PursuitStartDistance" => 0,
# "Rank" => "90",
# "Result" => "+9:05.9",
# "ResultOrder" => 90,
# "RunTime" => nil,
# "ShootingTotal" => "6",
# "Shootings" => "1+2+1+2",
# "ShortName" => "ZHANG Z.",
# "StartGroup" => nil,
# "StartInfo" => "17:02:45",
# "StartLane" => 0,
# "StartOrder" => 88,
# "StartRow" => 0,
# "StartTime" => "2019-12-05T16:02:45Z",
# "TeamId" => nil,
# "TeamRankAfterLeg" => nil,
# "TotalTime" => "51:41.0",
# "WC" => ""}

# %{"Behind" => "0.0", "Bib" => "1", "BibColor" => nil, "IBUId" => "BTNOR2          ", "IRM" => nil, "Leg" => 0, "LegRank" => nil, "NC" => "420", "NOC" => nil, "Name" => "NORWAY", "Nat" => "NOR", "PursuitStartDistance" => 0, "Rank" => "1", "Result" => "1:11:08.7", "ResultOrder" => 1, "RunTime" => nil, "ShootingTotal" => "0+10", "Shootings" => "0+4 0+6", "ShortName" => "NORWAY", "StartGroup" => nil, "StartInfo" => "Row 1", "StartLane" => 1, "StartOrder" => 1, "StartRow" => 1, "StartTime" => "0001-01-01T00:00:00", "TeamId" => nil, "TeamRankAfterLeg" => nil, "TotalTime" => "1:11:08.7", "WC" => "60"}
# %{"Behind" => "+13.0", "Bib" => "1", "BibColor" => nil, "IBUId" => "BTNOR20601199501", "IRM" => nil, "Leg" => 1, "LegRank" => "2", "NC" => nil, "NOC" => nil, "Name" => "KNOTTEN Karoline Offigstad", "Nat" => "NOR", "PursuitStartDistance" => 0, "Rank" => "1", "Result" => "+13.0", "ResultOrder" => 1, "RunTime" => nil, "ShootingTotal" => "0+1", "Shootings" => "0+1 0+0", "ShortName" => "KNOTTEN K.", "StartGroup" => nil, "StartInfo" => "Row 1", "StartLane" => 1, "StartOrder" => 2, "StartRow" => 1, "StartTime" => "0001-01-01T00:00:00", "TeamId" => nil, "TeamRankAfterLeg" => "2", "TotalTime" => "17:08.6", "WC" => nil}
