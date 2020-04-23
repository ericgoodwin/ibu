defmodule DateHelperTest do
  use ExUnit.Case
  doctest IBU.DateHelper
  alias IBU.DateHelper

  test "to_birth_date" do
    assert DateHelper.to_birth_date(nil) == nil
    assert DateHelper.to_birth_date("2020-01-10T12:00:00") == ~D[2020-01-10]
    assert DateHelper.to_birth_date("2020-01-10T12:00:00Z") == ~D[2020-01-10]
    assert DateHelper.to_birth_date("2020-01-10") == ~D[2020-01-10]
  end

  test "to_date_time" do
    assert DateHelper.to_date_time(nil) == nil

    assert DateHelper.to_date_time("2020-01-10T12:00:00Z") ==
             DateTime.from_naive!(~N[2020-01-10 12:00:00], "Etc/UTC")
  end
end
