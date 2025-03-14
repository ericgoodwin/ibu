defmodule IBU do
  use Tesla, only: [:get]

  plug(Tesla.Middleware.BaseUrl, "https://biathlonresults.com/modules/sportapi/api/")
  plug(Tesla.Middleware.Headers, [{"Accept", "application/json"}])
  plug(Tesla.Middleware.JSON)
  plug(Tesla.Middleware.Timeout, timeout: 5_000)
  plug(Tesla.Middleware.Logger)

  alias IBU.{Athlete, Event, Result, Race, Standing, Cup, Starting}

  @spec search_athletes(binary, binary | nil) :: {:ok, [Athlete.t()]} | {:error, any()}
  def search_athletes(last_name, first_name \\ nil) do
    case get("Athletes?FamilyName=#{last_name}&GivenName=#{first_name}") do
      {:error, reason} ->
        {:error, reason}

      {:ok, response} ->
        result =
          response
          |> Map.get(:body)
          |> Map.get("Athletes")
          |> Enum.filter(fn athlete ->
            Enum.member?(["Athlete", "Not active"], Map.get(athlete, "Functions"))
          end)
          |> Enum.map(&Athlete.build_from_api/1)

        {:ok, result}
    end
  end

  @spec get_standings(binary) :: {:error, any} | {:ok, [IBU.Standing.t()]}
  @doc """
  ## Examples
      iex> IBU.get_standings("BT1920SWRLCP__SWIN")
      {:ok,
        [
          %IBU.Standing{
            as_of: ~U[2020-03-13 17:39:17Z],
            athlete_ibu_id: "NOR",
            cup_ibu_id: "BT1920SWRLCP__SMNC",
            rank: 1,
            result_order: 1,
            score: 8192
          },
          ...
        ]
      }
  """
  def get_standings(cup_ibu_id) do
    case get("CupResults?CupId=#{cup_ibu_id}") do
      {:error, reason} ->
        {:error, reason}

      {:ok, response} ->
        body = Map.get(response, :body)

        result =
          Map.get(body, "Rows")
          |> Enum.map(&Standing.build_from_api(&1, cup_ibu_id, body["AsOf"]))

        {:ok, result}
    end
  end

  def get_cup(cup_ibu_id) do
    case get("CupResults?CupId=#{cup_ibu_id}") do
      {:error, reason} ->
        {:error, reason}

      {:ok, response} ->
        result =
          response
          |> Map.get(:body)
          |> Cup.build_from_api()

        {:ok, result}
    end
  end

  @spec get_events(integer) :: {:ok, [Event.t()]} | {:error, any()}
  def get_events(season_id \\ 1920) do
    case get("Events?SeasonId=#{season_id}") do
      {:error, reason} ->
        {:error, reason}

      {:ok, response} ->
        result =
          response
          |> Map.get(:body)
          |> Enum.filter(fn event ->
            Map.get(event, "Level") == 1
          end)
          |> Enum.map(&Event.build_from_api/1)

        {:ok, result}
    end
  end

  @doc """
  Get the details for a all the races at an event

  ## Examples
    iex> IBU.get_event_races("BT1920SWRLCP08")
    {:ok, [%IBU.Race{...}]}
  """
  @spec get_event_races(binary) :: {:ok, [Race.t()]} | {:error, any()}
  def get_event_races(event_id) do
    case get("Competitions?EventId=#{event_id}") do
      {:error, reason} ->
        {:error, reason}

      {:ok, response} ->
        result =
          response
          |> Map.get(:body)
          |> Enum.map(fn data -> Race.build_from_api(Map.put(data, "EventId", event_id)) end)

        {:ok, result}
    end
  end

  @doc """
  Get the details for a single race

  ## Examples
    iex> IBU.get_race_details("BT1920SWRLCP03SMSP")
    {:ok, %IBU.Race{...}, %IBU.Event{...}, []}
  """
  @spec get_race_details(binary) :: {:ok, Race.t(), Event.t(), list} | {:error, any()}
  def get_race_details(race_id) do
    case get("Results?RT=385698&RaceId=#{race_id}") do
      {:error, reason} ->
        {:error, reason}

      {:ok, response} ->
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
  end

  @spec get_race_results(binary) :: {:ok, [Result.t()]} | {:error, binary}
  def get_race_results(race_id) do
    case get("Results?RT=385698&RaceId=#{race_id}") do
      {:error, reason} ->
        {:error, reason}

      {:ok, %{body: %{"IsResult" => true, "Results" => results}}} ->
        result =
          results
          |> Enum.map(fn data -> Result.build_from_api(data, race_id) end)

        {:ok, result}

      {:ok, %{body: %{"IsResult" => false}}} ->
        {:error, :race_not_final}
    end
  end

  @spec get_race_starting_list(binary) :: {:ok, [Starting.t()]} | {:error, binary}
  def get_race_starting_list(race_id) do
    case get("Results?RT=385698&RaceId=#{race_id}") do
      {:error, reason} ->
        {:error, reason}

      {:ok, %{body: %{"IsResult" => false, "Results" => results}}} ->
        result =
          results
          |> Enum.map(fn data -> Starting.build_from_api(data, race_id) end)

        {:ok, result}

      {:ok, %{body: %{"IsResult" => true}}} ->
        {:error, :race_final}
    end
  end

  @doc """
  Get all details for an athlete

  ## Examples
    iex> IBU.get_athlete_details("BTGER12403199001")
    {:ok, [%IBU.Athlete{...}]}
  """
  @spec get_athlete_details(binary) :: {:ok, Athlete.t()} | {:error, any()}
  def get_athlete_details(ibu_id) do
    case get("CISBios?IBUId=#{String.trim(ibu_id)}") do
      {:error, reason} ->
        {:error, reason}

      {:ok, response} ->
        result =
          response
          |> Map.get(:body)
          |> Athlete.build_from_api()

        {:ok, result}
    end
  end
end
