defmodule Homedash.Data do
  alias Homedash.Repo
  import Ecto.Query, warn: false
  import Enum

  alias Homedash.Data.{Electricity, Gas, Solar}
  import Homedash.DateHelpers

  # Queries
  # -----------------------------------------------------------------------------

  @doc """
  Returns the timestamp of the latest measurement.
  Gas is chosen arbitrarily.

  All timestamps are converted to the local timezone.
  """
  def latest_measurement() do
    meter_reading(Gas)
    |> Map.get(:read_on)
  end

  @doc """
  Returns the meter reading for the given Struct (e.g., gas, electricity, or solar).
  Returns the struct so access to the date is also present.

  All timestamps are converted to the local timezone.
  """
  def meter_reading(struct) do
    query =
      from(dp in struct, order_by: [desc: :read_on])
      |> first()

    Repo.one(query)
    |> Map.update!(:read_on, &ensure_local/1)
  end

  @doc """
  Returns all the measurements for a given struct (RESOURCE INTENSIVE! FIX THIS YOU LAZY ASS)
  """
  def all(struct) do
    struct
    |> Repo.all()
    |> map(fn x -> Map.update!(x, :read_on, &ensure_local/1) end)
    |> sort_by(& &1.read_on, {:asc, DateTime})
  end

  @doc """
  Returns all measurements since a given timestamp.
  The timestamp is expected to be timezoned.

  All timestamps are converted to the local timezone.
  """
  def measurements_since(struct, oldest) do
    start = oldest |> ensure_utc()

    query =
      from dp in struct,
        where: dp.read_on >= ^start

    Repo.all(query)
    |> map(fn x -> Map.update!(x, :read_on, &ensure_local/1) end)
    |> sort_by(& &1.read_on, {:asc, DateTime})
  end

  @doc """
  Computes the total consumption per half hour.
  """
  def bucket_by_half_hour(struct, history \\ 1) do
    # Compute the oldest day data is required.
    oldest =
      now_tz()
      |> ensure_utc()
      |> truncate_day()
      |> add_days(-1 * (history - 1))

    # Create a query that selects all the data, but also computes the datetime in
    # the local timezone (necessary for binning properly).
    # *This assumes that the timezone on the database is set!*
    subquery =
      from v in struct,
        select: %{
          value: v.value,
          read_on: v.read_on,
          read_on_tz: fragment("(? AT TIME ZONE 'UTC')", v.read_on)
        },
        where: v.read_on >= ^oldest

    # Compute the bins of data by truncating on date.
    query =
      from v in subquery(subquery),
        select: %{
          read_on_group:
            fragment(
              "date_trunc('hour', ?) + date_part('minute', ?)::int / 30 * interval '30 min' AS read_on_group",
              v.read_on_tz,
              v.read_on_tz
            ),
          max: fragment("max(?)", v.value),
          min: fragment("min(?)", v.value)
        },
        group_by: fragment("read_on_group"),
        order_by: fragment("read_on_group asc")

    Repo.all(query)
    |> Enum.map(fn value ->
      Map.merge(value, %{read_on_group_local: ensure_local(value.read_on_group)})
    end)
  end

  @doc """
  Computes the total consumption per half hour.
  """
  def bucket_by_hour(struct, history \\ 1) do
    # Compute the oldest day data is required.
    oldest =
      now_tz()
      |> ensure_utc()
      |> truncate_day()
      |> add_days(-1 * (history - 1))

    # Create a query that selects all the data, but also computes the datetime in
    # the local timezone (necessary for binning properly).
    # *This assumes that the timezone on the database is set!*
    subquery =
      from v in struct,
        select: %{
          value: v.value,
          read_on: v.read_on,
          read_on_tz: fragment("(? AT TIME ZONE 'UTC')", v.read_on)
        },
        where: v.read_on >= ^oldest

    # Compute the bins of data by truncating on date.
    query =
      from v in subquery(subquery),
        select: %{
          read_on_group:
            fragment(
              "date_trunc('hour', ?) AS read_on_group",
              v.read_on_tz
            ),
          max: fragment("max(?)", v.value),
          min: fragment("min(?)", v.value)
        },
        group_by: fragment("read_on_group"),
        order_by: fragment("read_on_group asc")

    Repo.all(query)
    |> Enum.map(fn value ->
      Map.merge(value, %{read_on_group_local: ensure_local(value.read_on_group)})
    end)
  end

  def debug() do
    # Create a query that selects all the data, but also computes the datetime in
    # the local timezone (necessary for binning properly).
    # *This assumes that the timezone on the database is set!*
    subquery =
      from v in Gas,
        select: %{
          value: v.value,
          read_on: v.read_on,
          read_on_tz: fragment("(? AT TIME ZONE 'UTC')", v.read_on)
        }

    # Compute the bins of data by truncating on date.
    query =
      from v in subquery(subquery),
        select: %{
          read_on_tz: fragment("read_on_tz"),
          read_on: v.read_on,
          value: v.value
        },
        limit: 4,
        order_by: fragment("read_on desc")

    Repo.all(query)
    |> Enum.map(fn value ->
      Map.merge(value, %{read_on_tz: ensure_local(value.read_on_tz)})
    end)
  end

  @doc """
  Computes the total consumption per day.
  """
  def bucket_by_day(struct, history \\ 30) do
    # Compute the oldest day data is required.
    oldest =
      now_tz()
      |> ensure_utc()
      |> truncate_day()
      |> add_days(-1 * (history - 1))

    # Create a query that selects all the data, but also computes the datetime in
    # the local timezone (necessary for binning properly).
    # *This assumes that the timezone on the database is set!*
    subquery =
      from v in struct,
        select: %{
          value: v.value,
          read_on: v.read_on,
          read_on_tz: fragment("(? AT TIME ZONE 'UTC')", v.read_on)
        },
        where: v.read_on >= ^oldest

    # Compute the bins of data by truncating on date.
    query =
      from v in subquery(subquery),
        select: %{
          read_on_group:
            fragment(
              "date_trunc('day', ?) as read_on_group",
              v.read_on_tz
            ),
          max: fragment("max(?)", v.value),
          min: fragment("min(?)", v.value)
        },
        group_by: fragment("read_on_group"),
        order_by: fragment("read_on_group asc")

    Repo.all(query)
    |> Enum.map(fn value ->
      Map.merge(value, %{read_on_group_local: ensure_local(value.read_on_group)})
    end)
  end

  @doc """
  Computes the total consumption per week.
  """
  def bucket_by_week(struct, history \\ 30) do
    # Compute the oldest day data is required.
    oldest =
      now_tz()
      |> ensure_utc()
      |> truncate_day()
      |> add_days(-1 * (history - 1))

    # Create a query that selects all the data, but also computes the datetime in
    # the local timezone (necessary for binning properly).
    # *This assumes that the timezone on the database is set!*
    subquery =
      from v in struct,
        select: %{
          value: v.value,
          read_on: v.read_on,
          read_on_tz: fragment("(? AT TIME ZONE 'UTC')", v.read_on)
        },
        where: v.read_on >= ^oldest

    # Compute the bins of data by truncating on date.
    query =
      from v in subquery(subquery),
        select: %{
          read_on_group:
            fragment(
              "date_trunc('week', ?) as read_on_group",
              v.read_on_tz
            ),
          max: fragment("max(?)", v.value),
          min: fragment("min(?)", v.value)
        },
        group_by: fragment("read_on_group"),
        order_by: fragment("read_on_group asc")

    Repo.all(query)
    |> Enum.map(fn value ->
      Map.merge(value, %{read_on_group_local: ensure_local(value.read_on_group)})
    end)
  end

  @doc """
  Returns the total consumption since a day in the past.
  The day in the past should be given in the local timezone!

  All timestamps are converted to the local timezone.
  """
  def consumption_since(struct, oldest) do
    # Compute the oldest day data is required.
    oldest = oldest |> ensure_utc()

    # Create a query that selects all the data, but also computes the datetime in
    # the local timezone (necessary for binning properly).
    # *This assumes that the timezone on the database is set!*
    subquery =
      from v in struct,
        select: %{
          value: v.value,
          read_on: v.read_on,
          read_on_tz: fragment("(? AT TIME ZONE 'UTC')", v.read_on)
        },
        where: v.read_on >= ^oldest

    # Compute the bins of data by truncating on date.
    query =
      from v in subquery(subquery),
        select: %{
          total: fragment("max(?) - min(?)", v.value, v.value)
        }

    %{total: res} = Repo.one(query)
    if res, do: res, else: 0.0
  end

  @doc """
  Insert a measurement into the database. All timestamps should be UTC.
  """
  def insert_measurement(struct, attrs) do
    struct(struct)
    |> struct.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Computes the average daily consumption of the last `days` days.
  """
  def day_average(struct, days) do
    days_ago = now_tz() |> truncate_day() |> add_days(-1 * days)
    consumption_since(struct, days_ago) / days
  end

  # Gas
  # -----------------------------------------------------------------------------

  def gas_daily_average(days \\ 30), do: day_average(Gas, days)

  def gas_today(), do: consumption_since(Gas, now_tz() |> truncate_day())

  def meter_reading_gas(), do: meter_reading(Gas)

  def all_gas(), do: all(Gas)

  def all_gas_since(oldest), do: measurements_since(Gas, oldest)

  def recent_gas(days \\ 7), do: bucket_by_hour(Gas, days)

  def historical_gas(days \\ 14), do: bucket_by_day(Gas, days)

  def insert_gas(attrs \\ %{}), do: insert_measurement(Gas, attrs)

  # Solar
  # -----------------------------------------------------------------------------

  def solar_daily_average(days \\ 30), do: day_average(Solar, days)

  def solar_today(), do: consumption_since(Solar, now_tz() |> truncate_day())

  def meter_reading_solar(), do: meter_reading(Solar)

  def all_solar(), do: all(Solar)

  def all_solar_since(oldest), do: measurements_since(Solar, oldest)

  def recent_solar(days \\ 7), do: bucket_by_hour(Solar, days)

  def historical_solar(days \\ 14), do: bucket_by_day(Solar, days)

  def insert_solar(attrs \\ %{}), do: insert_measurement(Solar, attrs)

  # Electricity
  # -----------------------------------------------------------------------------
  def electricity_daily_average(days \\ 30), do: day_average(Electricity, days)

  def electricity_today(), do: consumption_since(Electricity, now_tz() |> truncate_day())

  def meter_reading_electricity(), do: meter_reading(Electricity)

  def all_electricity(), do: all(Electricity)

  def all_electricity_since(oldest), do: measurements_since(Electricity, oldest)

  def recent_electricity(days \\ 7), do: bucket_by_hour(Electricity, days)

  def historical_electricity(days \\ 14), do: bucket_by_day(Electricity, days)

  def insert_electricity(attrs \\ %{}), do: insert_measurement(Electricity, attrs)
end
