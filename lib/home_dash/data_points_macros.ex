defmodule HomeDash.DataPoints.Macros do
  alias HomeDash.Repo
  import Ecto.Query, warn: false

  defmacro datapoint(name, struct_name) do
    # name_atom = String.to_atom(name)
    # ---------------------------------------------------------------------------
    # list_*_datapoints
    function_name = "list_#{name}_datapoints" |> String.to_atom()

    list_datapoints =
      quote do
        def unquote(function_name)() do
          Repo.all(unquote(struct_name))
        end
      end

    # ---------------------------------------------------------------------------
    # last_*_reading
    function_name = "last_#{name}_reading" |> String.to_atom()

    last_reading =
      quote do
        def unquote(function_name)() do
          query =
            from(dp in unquote(struct_name),
              order_by: [desc: :read_on]
            )
            |> first()

          Repo.one(query)
        end
      end

    # ---------------------------------------------------------------------------
    # total_*_usage_in_range

    function_name = "total_#{name}_usage_in_range" |> String.to_atom()
    frag_max = "select max(read_on) from #{name}_datapoints where read_on between ? and ?"
    frag_min = "select min(read_on) from #{name}_datapoints where read_on between ? and ?"

    total_usage_in_range =
      quote do
        def unquote(function_name)(%DateTime{} = start, %DateTime{} = finish) do
          # Get the oldest measurement first.
          query =
            from dp in unquote(struct_name),
              where: dp.read_on in fragment(unquote(frag_min), ^start, ^finish),
              select: dp

          first_reading = Repo.one(query)
          # Get the lowest measurement first.
          query =
            from dp in unquote(struct_name),
              where:
                dp.read_on in fragment(
                  unquote(frag_max),
                  ^start,
                  ^finish
                ),
              select: dp

          last_reading = Repo.one(query)

          case {last_reading, first_reading} do
            {nil, nil} ->
              0.0

            {nil, reading} ->
              reading.value

            {reading, nil} ->
              reading.value

            {reading, reading} ->
              reading.value

            {max, min} ->
              max.value - min.value
          end
        end
      end

    # ---------------------------------------------------------------------------
    # list_*_day_totals
    function_name = "list_#{name}_day_totals_last_n_days" |> String.to_atom()

    list_day_totals =
      quote do
        def unquote(function_name)(n \\ 7) do
          0..(n - 1)
          |> Enum.map(fn day ->
            day =
              DateTime.now!("Etc/UTC")
              |> start_of_day()
              |> DateTime.add(-1 * day * 24 * 60 * 60, :second, Calendar.get_time_zone_database())

            day_start = start_of_day(day)
            day_end = end_of_day(day)
            {day |> DateTime.to_date(), unquote(String.to_atom("total_#{name}_usage_in_range"))(day_start, day_end)}
          end)
        end
      end

    # ---------------------------------------------------------------------------
    # total_*_today
    function_name = "total_#{name}_today" |> String.to_atom()

    total_today =
      quote do
        def unquote(function_name)() do
          today = unquote(String.to_atom("list_#{name}_datapoints_since"))(start_of_day())

          case today do
            [] ->
              0.0

            [reading] ->
              reading.value

            _ ->
              last_measurement = List.last(today)
              first_measurement = List.first(today)
              last_measurement.value - first_measurement.value
          end
        end
      end

    # ---------------------------------------------------------------------------
    # total_*_hourly
    function_name = "total_#{name}_hourly" |> String.to_atom()

    total_hourly =
      quote do
        def unquote(function_name)() do
          today = unquote(String.to_atom("list_#{name}_datapoints_since"))(start_of_day())

          today
          |> Enum.group_by(fn measurement ->
            measurement.read_on |> truncate_datetime_hour()
          end)
          |> Enum.map(fn {hour, values} ->
            case values do
              [measurement] ->
                {hour, 0.0}

              values ->
                first = values |> Enum.sort_by(fn reading -> reading.read_on end) |> List.first()
                last = values |> Enum.sort_by(fn reading -> reading.read_on end) |> List.last()
                consumption = last.value - first.value
                {hour, consumption}
            end
          end)
        end
      end

    # ---------------------------------------------------------------------------
    # total_*_quarterly
    function_name = "total_#{name}_quarterly" |> String.to_atom()

    total_quarterly =
      quote do
        def unquote(function_name)() do
          today = unquote(String.to_atom("list_#{name}_datapoints_since"))(n_hours_ago(8))

          today
          |> Enum.group_by(fn measurement ->
            measurement.read_on |> truncate_datetime_quarterly()
          end)
          |> Enum.map(fn {quarter, values} ->
            case values do
              [measurement] ->
                {quarter, 0.0}

              values ->
                first = values |> Enum.sort_by(fn reading -> reading.read_on end) |> List.first()
                last = values |> Enum.sort_by(fn reading -> reading.read_on end) |> List.last()
                consumption = last.value - first.value
                {quarter, consumption}
            end
          end)
        end
      end

    # ---------------------------------------------------------------------------
    # list_*_datapoints_since
    function_name = "list_#{name}_datapoints_since" |> String.to_atom()

    list_datapoints_since =
      quote do
        def unquote(function_name)(start) do
          query =
            from dp in unquote(struct_name),
              where: dp.read_on > ^start

          Repo.all(query)
        end
      end

    # ---------------------------------------------------------------------------
    # list_*_datapoints_between
    function_name = "list_#{name}_datapoints_between" |> String.to_atom()

    list_datapoints_between =
      quote do
        def unquote(function_name)(start, finish) do
          query =
            from dp in unquote(struct_name),
              where: dp.read_on > ^start and dp.read_on < ^finish

          Repo.all(query)
        end
      end

    # ---------------------------------------------------------------------------
    # create_*_data_point

    function_name = "create_#{name}_data_point" |> String.to_atom()

    create_data_point =
      quote do
        def unquote(function_name)(attrs \\ %{}) do
          %unquote(struct_name){}
          |> unquote(struct_name).changeset(attrs)
          |> Repo.insert()
        end
      end

    # ---------------------------------------------------------------------------
    # delete_*_data_point

    function_name = "delete_#{name}_data_point" |> String.to_atom()

    delete_data_point =
      quote do
        def unquote(function_name)(%unquote(struct_name){} = data_point) do
          Repo.delete(data_point)
        end
      end

    # ---------------------------------------------------------------------------
    # change_*_data_point

    function_name = "change_#{name}_data_point" |> String.to_atom()

    change_data_point =
      quote do
        def unquote(function_name)(%unquote(struct_name){} = data_point, attrs \\ %{}) do
          unquote(struct_name).changeset(data_point, attrs)
        end
      end

    # ---------------------------------------------------------------------------
    # Inject all the functions.
    quote do
      unquote(list_datapoints)
      unquote(last_reading)
      unquote(list_day_totals)
      unquote(total_today)
      unquote(list_datapoints_since)
      unquote(list_datapoints_between)
      unquote(create_data_point)
      unquote(delete_data_point)
      unquote(change_data_point)
      unquote(total_usage_in_range)
      unquote(total_hourly)
      unquote(total_quarterly)
    end
  end

  # /defmacro
end

# /defmodule
