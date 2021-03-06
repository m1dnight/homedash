defmodule Homedash.DateHelpers do
  @doc """
  Given a DateTime struct, ensures that its in UTC.
  """
  def ensure_utc(dt) do
    DateTime.shift_zone!(dt, "Etc/UTC")
  end

  @doc """
  Given a DateTime, ensures that it's in the current timezone configured using the config file.
  """
  def ensure_local(%NaiveDateTime{} = dt), do: ensure_local(DateTime.from_naive!(dt, "Etc/UTC"))

  def ensure_local(dt) do
    tz = Application.get_env(:homedash, :timezone)
    DateTime.shift_zone!(dt, tz)
  end

  @doc """
  Returns the current DateTime in the current timezone.
  """
  def now_tz() do
    tz = Application.get_env(:homedash, :timezone)
    DateTime.now!(tz)
  end

  @doc """
  Adds `n` days to the given DateTime.
  """
  def add_days(dt, n) do
    dt
    |> Timex.shift(days: n)
  end

  @doc """
  Returns the first day of the week of the given datetime.
  """
  def truncate_week(datetime) do
    offset = Date.day_of_week(datetime) - 1

    datetime
    |> truncate_day()
    |> add_days(-1 * offset)
  end

  @doc """
  Sets the time portion of the DateTime to 0.
  """
  def truncate_day(datetime) do
    datetime
    |> Map.put(:minute, 0)
    |> Map.put(:second, 0)
    |> Map.put(:microsecond, {0, 0})
    |> Map.put(:hour, 0)
  end

  @doc """
  Returns the datetime but with the minutes set to 0.
  """
  def truncate_hour(datetime) do
    datetime
    |> Map.put(:minute, 0)
    |> Map.put(:second, 0)
    |> Map.put(:microsecond, {0, 0})
  end
end
