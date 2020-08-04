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
    # list_*_day_totals
    function_name = "list_#{name}_day_totals" |> String.to_atom()

    list_day_totals =
      quote do
        def unquote(function_name)() do
          # query = from dp in ElectricityDataPoint, select: count(dp)
          query =
            from dp in unquote(struct_name),
              group_by: fragment("date_trunc('day', ?)", dp.read_on),
              order_by: fragment("date_trunc('day', ?)", dp.read_on),
              limit: 7,
              select: {fragment("sum(value)"), fragment("date_trunc('day', ?)", dp.read_on)}

          Repo.all(query)
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
    # list_*_datapoints_since
    function_name = "list_#{name}_datapoints_since" |> String.to_atom()

    list_datapoints_since =
      quote do
        def unquote(function_name)(start) do
          unquote(String.to_atom("list_#{name}_datapoints_between"))(
            start,
            DateTime.now!("Etc/UTC")
          )
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
    end
  end

  # /defmacro
end

# /defmodule
