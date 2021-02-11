# Script for populating the database. You can run it as:
#
#     mix run priv/repo/dev_data.exs
#

defmodule Inserter do
  @end_meter 123_456_789
  # Seconds
  @days_back 120 * 86400
  @minutes_between_measurements 4

  def now() do
    tz = Application.get_env(:homedash, :timezone)
    DateTime.now!(tz)
  end

  def add_minutes(dt, delta) do
    DateTime.add(dt, delta * 60, :second, Calendar.get_time_zone_database())
  end

  def add_days(dt, delta) do
    DateTime.add(dt, delta * 24 * 60 * 60, :second, Calendar.get_time_zone_database())
  end

  def insert(inserter, meter, previous) do
    new_meter = meter - :crypto.rand_uniform(1, 3) * 1.0
    current = add_minutes(previous, -1 * 3)

    inserter.(%{value: new_meter, read_on: current})

    if abs(DateTime.diff(current, now(), :second)) < @days_back do
      insert(inserter, new_meter, current)
    end
  end

  def insert_all() do
    t1 = Task.async(fn -> insert(&Homedash.Data.insert_gas/1, @end_meter, now()) end)
    t2 = Task.async(fn -> insert(&Homedash.Data.insert_solar/1, @end_meter, now()) end)
    t3 = Task.async(fn -> insert(&Homedash.Data.insert_electricity/1, @end_meter, now()) end)

    Task.await(t1, :infinity)
    Task.await(t2, :infinity)
    Task.await(t3, :infinity)
  end
end

Inserter.insert_all()
