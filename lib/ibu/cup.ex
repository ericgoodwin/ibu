defmodule Ibu.Cup do
  import Ibu.DateHelper, only: [to_date_time: 1]

  defstruct([
    :ibu_id,
    :as_of,
    :description,
    :name,
    :short_name,
    :completed_races,
    :total_races,
    :standings
  ])

  @type t :: %__MODULE__{
          ibu_id: binary,
          as_of: DateTime.t(),
          description: binary,
          name: binary,
          short_name: binary,
          completed_races: integer,
          total_races: integer,
          standings: list
        }

  @spec build_from_api(map) :: t
  def build_from_api(data) when is_map(data) do
    %__MODULE__{
      ibu_id: data["CupId"],
      as_of: data["AsOf"] |> to_date_time,
      description: data["CupInfo"] |> String.capitalize,
      name: data["CupName"],
      short_name: data["CupShortName"],
      completed_races: data["RaceCount"],
      total_races: data["TotalRaces"],
      standings: Enum.map(data["Rows"], &Ibu.Standing.build_from_api(&1, data["CupId"], data["AsOf"]))
    }
  end

  @spec ibu_ids(integer) :: [binary]
  def ibu_ids(season_id) do
    prefix = ["BT#{season_id}SWRLCP__"]
    Enum.reduce(~w(TS IN PU MS RL SP NC), ["#{prefix}MXRL"], fn (type, acc) ->
      ["#{prefix}SW#{type}", "#{prefix}SM#{type}"] ++ acc
    end)
  end
end
