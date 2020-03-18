defmodule Ibu.Result do

  defstruct([:order, :athlete_ibu_id, :race_ibu_id, :country_code, :behind, :bib, :bib_color, :irm, :leg, :leg_rank, :nc, :noc, :name, :pursuit_start_distance, :rank, :result, :run_time, :shooting_total, :shootings, :short_name, :start_group, :start_info, :start_lane, :start_order, :start_row, :start_time, :team_id, :team_rank_after_leg, :total_time, :wc])

  @type t :: %__MODULE__{
          order: integer,
          athlete_ibu_id: binary,
          race_ibu_id: binary,
          country_code: binary,
          behind: binary,
          bib: binary,
          bib_color: binary,
          irm: binary,
          leg: binary,
          leg_rank: binary,
          nc: binary,
          noc: binary,
          name: binary,
          pursuit_start_distance: integer,
          rank: binary,
          result: binary,
          run_time: binary,
          shooting_total: binary,
          shootings: binary,
          short_name: binary,
          start_group: binary,
          start_info: binary,
          start_lane: binary,
          start_order: integer,
          start_row: integer,
          start_time: binary,
          team_id: binary,
          team_rank_after_leg: binary,
          total_time: binary,
          wc: binary,
        }

  @spec build_from_api(map, binary) :: t
  def build_from_api(data, race_id) when is_map(data) do
    %__MODULE__{
      order: data["ResultOrder"],
      athlete_ibu_id: data["IBUId"],
      country_code: data["Nat"],
      race_ibu_id: race_id,
      behind: data["Behind"],
      bib: data["Bib"],
      bib_color: data["BibColor"],
      irm: data["IRM"],
      leg: data["Leg"],
      leg_rank: data["LegRank"],
      nc: data["NC"],
      noc: data["NOC"],
      name: data["Name"],
      pursuit_start_distance: data["PursuitStartDistance"],
      rank: data["Rank"],
      result: data["Result"],
      run_time: data["RunTime"],
      shooting_total: data["ShootingTotal"],
      shootings: data["Shootings"],
      short_name: data["ShortName"],
      start_group: data["StartGroup"],
      start_info: data["StartInfo"],
      start_lane: data["StartLane"],
      start_order: data["StartOrder"],
      start_row: data["StartRow"],
      start_time: data["StartTime"],
      team_id: data["TeamId"],
      team_rank_after_leg: data["TeamRankAfterLeg"],
      total_time: data["TotalTime"],
      wc: data["WC"],
    }
  end
end
