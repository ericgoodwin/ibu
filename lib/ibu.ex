defmodule Ibu do
  use Tesla

  plug(Tesla.Middleware.BaseUrl, "https://biathlonresults.com/modules/sportapi/api/")
  plug(Tesla.Middleware.Headers, [{"Accept", "application/json"}])
  plug(Tesla.Middleware.JSON)

  alias Ibu.{Athlete, Event, Result, Race}

  @spec search_athletes(binary, binary | nil) :: [Athlete.t()]
  def search_athletes(last_name, first_name \\ nil) do
    {:ok, response} = get("Athletes?FamilyName=#{last_name}&GivenName=#{first_name}")

    response
    |> Map.get(:body)
    |> Map.get("Athletes")
    |> Enum.filter(fn athlete ->
      Map.get(athlete, "Functions") == "Athlete"
    end)
    |> Enum.map(&Athlete.build_from_api/1)
  end

  @spec get_events(integer) :: [Event.t()]
  def get_events(season_id \\ 1920) do
    {:ok, response} = get("Events?SeasonId=#{season_id}")

    response
    |> Map.get(:body)
    |> Enum.filter(fn event ->
      Map.get(event, "Level") == 1
    end)
    |> Enum.map(&Event.build_from_api/1)
  end

  @spec get_event_races(binary) :: [Race.t()]
  def get_event_races(event_id) do
    {:ok, response} = get("Competitions?EventId=#{event_id}")

    response
    |> Map.get(:body)
    |> Enum.map(&Race.build_from_api/1)
  end

  @spec get_race_details(binary) :: Race.t()
  def get_race_details(race_id) do
    {:ok, response} = get("Results?RaceId=#{race_id}")

    response
    |> Map.get(:body)
    |> Map.get("Competition")
    |> Race.build_from_api()
  end

  @spec get_race_results(binary) :: [Result.t()]
  def get_race_results(race_id) do
    {:ok, response} = get("Results?RaceId=#{race_id}")

    body =
      response
      |> Map.get(:body)

    case(body["IsResult"]) do
      true -> body["Results"]
      _ -> []
    end
    |> Enum.map(fn data -> Result.build_from_api(data, race_id) end)
  end

  @spec get_athlete_details(binary) :: Athlete.t()
  def get_athlete_details(ibu_id) do
    {:ok, response} = get("CISBios?IBUId=#{ibu_id}")

    response
    |> Map.get(:body)
    |> Athlete.build_from_api()
  end
end
