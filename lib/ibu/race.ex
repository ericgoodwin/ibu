defmodule IBU.Race do
  import IBU.DateHelper, only: [to_date_time: 1]

  defstruct([
    :category_code,
    :description,
    :discipline_code,
    :has_spare_rounds,
    :ibu_id,
    :kilometers,
    :legs,
    :penalty_seconds,
    :shooting_positions,
    :shootings,
    :short_description,
    :spare_rounds,
    :start_mode,
    :start_time,
    :status_code,
    :status_text,
    :event_id
  ])

  @type t :: %__MODULE__{
          category_code: binary,
          description: binary,
          discipline_code: binary,
          has_spare_rounds: boolean,
          ibu_id: binary,
          kilometers: binary,
          legs: integer,
          penalty_seconds: integer,
          shooting_positions: binary,
          shootings: integer,
          short_description: binary,
          spare_rounds: integer,
          start_mode: binary,
          start_time: DateTime.t(),
          status_code: integer,
          status_text: binary,
          event_id: binary
        }

  @spec complete?(t) :: boolean
  def complete?(%__MODULE__{status_text: "Final"}), do: true
  def complete?(%__MODULE__{status_text: _}), do: false

  @spec build_from_api(map) :: t
  def build_from_api(data) when is_map(data) do
    %__MODULE__{
      category_code: data["catId"],
      description: data["Description"],
      discipline_code: data["DisciplineId"],
      has_spare_rounds: data["HasSpareRounds"],
      ibu_id: data["RaceId"],
      kilometers: data["km"],
      legs: data["NrLegs"],
      penalty_seconds: data["PenaltySeconds"],
      shooting_positions: data["ShootingPositions"],
      shootings: data["NrShootings"],
      short_description: data["ShortDescription"],
      spare_rounds: data["NrSpareRounds"],
      start_mode: data["StartMode"],
      start_time: data["StartTime"] |> to_date_time,
      status_code: data["StatusId"],
      status_text: data["StatusText"],
      event_id: data["EventId"]
    }
  end
end
