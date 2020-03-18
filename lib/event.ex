defmodule Ibu.Event do
  import Ibu.DateHelper, only: [to_date_time: 1]

  defstruct([
    :country_code,
    :description,
    :end_date,
    :event_classification_code,
    :ibu_id,
    :is_actual,
    :is_current,
    :metal_set_code,
    :organizer_code,
    :organizer,
    :season_code,
    :short_description,
    :start_date,
    :utc_offset
  ])

  @type t :: %__MODULE__{
          country_code: binary,
          description: binary,
          end_date: DateTime.t(),
          event_classification_code: binary,
          ibu_id: binary,
          is_actual: boolean,
          is_current: boolean,
          metal_set_code: binary,
          organizer_code: binary,
          organizer: binary,
          season_code: binary,
          short_description: binary,
          start_date: DateTime.t(),
          utc_offset: integer
        }

  @spec build_from_api(map) :: t
  def build_from_api(data) when is_map(data) do
    %__MODULE__{
      country_code: data["Nat"],
      description: data["Description"],
      end_date: data["EndDate"] |> to_date_time,
      event_classification_code: data["EventClassificationId"],
      ibu_id: data["EventId"],
      organizer: data["Organizer"],
      organizer_code: data["OrganizerId"],
      season_code: data["SeasonId"],
      short_description: data["ShortDescription"],
      start_date: data["StartDate"] |> to_date_time,
      utc_offset: data["UTCOffset"],
      metal_set_code: data["MedalSetId"],
      is_actual: data["IsActual"],
      is_current: data["IsCurrent"]
    }
  end
end
