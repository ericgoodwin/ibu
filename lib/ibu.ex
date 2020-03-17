defmodule Ibu do
  use Tesla

  plug(Tesla.Middleware.BaseUrl, "https://biathlonresults.com/modules/sportapi/api/")
  plug(Tesla.Middleware.Headers, [{"Accept", "application/json"}])
  plug(Tesla.Middleware.JSON)

  alias Ibu.{Athlete, Event, Result, Race}

  @spec search_athletes(binary, binary | nil) :: {:ok, [Athlete.t()]}
  def search_athletes(last_name, first_name \\ nil) do
    {:ok, response} = get("Athletes?FamilyName=#{last_name}&GivenName=#{first_name}")

    result =
      response
      |> Map.get(:body)
      |> Map.get("Athletes")
      |> Enum.filter(fn athlete ->
        Map.get(athlete, "Functions") == "Athlete"
      end)
      |> Enum.map(&Athlete.build_from_api/1)

    {:ok, result}
  end

  @spec get_events(integer) :: {:ok, [Event.t()]}
  def get_events(season_id \\ 1920) do
    {:ok, response} = get("Events?SeasonId=#{season_id}")

    result =
      response
      |> Map.get(:body)
      |> Enum.filter(fn event ->
        Map.get(event, "Level") == 1
      end)
      |> Enum.map(&Event.build_from_api/1)

    {:ok, result}
  end

  @doc """
  Get the details for a all the races at an event

  ## Examples
    iex> Ibu.get_event_races("BT1920SWRLCP08")
    {:ok, [%Ibu.Race{...}]}
  """
  @spec get_event_races(binary) :: {:ok, [Race.t()]}
  def get_event_races(event_id) do
    {:ok, response} = get("Competitions?EventId=#{event_id}")

    result =
      response
      |> Map.get(:body)
      |> Enum.map(fn data -> Race.build_from_api(Map.put(data, "EventId", event_id)) end)

    {:ok, result}
  end

  @doc """
  Get the details for a single race

  ## Examples
    iex> Ibu.get_race_details("BT1920SWRLCP08MXRL")
    {:ok, %Ibu.Race{...}, %Ibu.Event{...}, []}
  """
  @spec get_race_details(binary) :: {:ok, Race.t(), Event.t(), list}
  def get_race_details(race_id) do
    {:ok, response} = get("Results?RaceId=#{race_id}")

    body = Map.get(response, :body)

    event =
      body
      |> Map.get("SportEvt")
      |> Event.build_from_api()

    race = Map.get(body, "Competition")
    race = Map.put(race, "EventId", event.ibu_id)
    race = Race.build_from_api(race)

    results =
      case(Race.complete?(race)) do
        true ->
          body
          |> Map.get("Results")
          |> Enum.map(fn result -> Result.build_from_api(result, race_id) end)

        false ->
          {:error, :race_not_final}
      end

    {:ok, race, event, results}
  end

  @spec get_race_results(binary) :: {:ok, [Result.t()]} | {:error, binary}
  def get_race_results(race_id) do
    case get("Results?RaceId=#{race_id}") do
      {:ok, %{body: %{"IsResult" => true, "Results" => results}}} ->
        result = Enum.map(results, fn data -> Result.build_from_api(data, race_id) end)
        {:ok, result}

      {:ok, %{body: %{"IsResult" => false}}} ->
        {:error, :race_not_final}

      _ ->
        {:error, :unknown_error}
    end
  end

  @spec get_athlete_details(binary) :: {:ok, Athlete.t()}
  def get_athlete_details(ibu_id) do
    case get("CISBios?IBUId=#{ibu_id}") do
      {:ok, response} ->
        result =
        response
        |> Map.get(:body)
        |> Athlete.build_from_api()
        {:ok, result}
      {:error, :invalid_uri} -> {:error, :invalid_uri}

    end


  end
end
