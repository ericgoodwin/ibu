defmodule IBU.Athlete do
  import IBU.DateHelper, only: [to_birth_date: 1]
  alias IBU.Stats

  defstruct([
    :family_name,
    :given_name,
    :birth_date,
    :gender,
    :ibu_id,
    :flag_uri,
    :photo_uri,
    :country_code,
    :status,
    :stats
  ])

  @type t :: %__MODULE__{
          family_name: binary,
          given_name: binary,
          birth_date: Date.t(),
          gender: binary,
          ibu_id: binary,
          flag_uri: binary,
          photo_uri: binary,
          country_code: binary,
          status: binary,
          stats: list
        }

  @spec build_from_api(map) :: t
  def build_from_api(data) when is_map(data) do
    %__MODULE__{
      family_name: data["FamilyName"],
      given_name: data["GivenName"],
      birth_date: data["Birthdate"] |> to_birth_date,
      gender: data["GenderId"],
      ibu_id: data["IBUId"],
      flag_uri: data["FlagURI"],
      photo_uri: data["PhotoURI"],
      country_code: data["NAT"],
      status: get_status(data["Functions"]),
      stats: Stats.build(data)
    }
  end

  @spec get_status(binary) :: binary
  defp get_status("Athlete"), do: "athlete"
  defp get_status("Athlete, Official"), do: "athlete"
  defp get_status("Not active"), do: "inactive"
  defp get_status("Official"), do: "official"
  defp get_status(nil), do: nil
end
