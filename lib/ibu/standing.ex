defmodule IBU.Standing do
  import IBU.DateHelper, only: [to_date_time: 1]

  defstruct([
    :athlete_ibu_id,
    :rank,
    :result_order,
    :score,
    :cup_ibu_id,
    :as_of
  ])

  @type t :: %__MODULE__{
          athlete_ibu_id: binary,
          rank: integer,
          result_order: integer,
          score: integer,
          cup_ibu_id: binary,
          as_of: DateTime.t()
        }

  @spec build_from_api(map, binary, binary) :: t
  def build_from_api(data, cup_id, as_of) when is_map(data) do
    %__MODULE__{
      athlete_ibu_id: String.trim(data["IBUId"]),
      rank: String.to_integer(data["Rank"]),
      result_order: data["ResultOrder"],
      score: String.to_integer(data["Score"]),
      cup_ibu_id: cup_id,
      as_of: as_of |> to_date_time
    }
  end
end
