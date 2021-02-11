defmodule Parser do
  def start?(line) do
    Regex.match?(~r".*Brussels.*", line)
  end

  # Predicates
  # -----------------------------------------------------------------------------
  def is_gas_reading(line), do: String.starts_with?(line, "0-1:24.2.3")

  def is_day_elec_usage(line), do: String.starts_with?(line, "1-0:1.8.1")

  def is_night_elec_usage(line), do: String.starts_with?(line, "1-0:1.8.2")

  def is_day_elec_inject(line), do: String.starts_with?(line, "1-0:2.8.1")

  @spec is_night_elec_inject(binary) :: boolean
  def is_night_elec_inject(line), do: String.starts_with?(line, "1-0:2.8.2")

  def wanted?(line) do
    is_gas_reading(line) or is_day_elec_usage(line) or is_night_elec_usage(line) or
      is_day_elec_inject(line) or is_night_elec_inject(line) or start?(line)
  end

  # Parsers
  # -----------------------------------------------------------------------------
  def parse_gas_reading(line) do
    %{"val" => v} = Regex.named_captures(~r"\((?<val>\d+\.\d+)\*m3\)", line)
    {fl, ""} = Float.parse(v)
    fl
  end

  @spec parse_day_elec_usage(binary) :: float
  def parse_day_elec_usage(line) do
    %{"val" => v} = Regex.named_captures(~r"\((?<val>\d+\.\d+)\*kWh\)", line)
    {fl, ""} = Float.parse(v)
    fl
  end

  def parse_day_elec_inject(line) do
    %{"val" => v} = Regex.named_captures(~r"\((?<val>\d+\.\d+)\*kWh\)", line)
    {fl, ""} = Float.parse(v)
    fl
  end

  def parse_night_elec_inject(line) do
    %{"val" => v} = Regex.named_captures(~r"\((?<val>\d+\.\d+)\*kWh\)", line)
    {fl, ""} = Float.parse(v)
    fl
  end

  def parse_night_elec_usage(line) do
    %{"val" => v} = Regex.named_captures(~r"\((?<val>\d+\.\d+)\*kWh\)", line)
    {fl, ""} = Float.parse(v)
    fl
  end

  def parse_timestamp(line) do
    try do
      Timex.parse!(line, "%a %d %b %Y %I:%M:%S %p %Z", :strftime)
    rescue
      _ ->
        nil
    catch
      _ ->
        nil
    end
  end

  def parse_chunk(lines) do
    lines
    |> Enum.reduce(%{}, fn line, acc ->
      cond do
        is_gas_reading(line) ->
          Map.put(acc, :gas, parse_gas_reading(line))

        is_night_elec_inject(line) ->
          Map.put(acc, :night_elec_inject, parse_night_elec_inject(line))

        is_day_elec_inject(line) ->
          Map.put(acc, :day_elec_inject, parse_day_elec_inject(line))

        is_night_elec_usage(line) ->
          Map.put(acc, :night_elec_usage, parse_night_elec_usage(line))

        is_day_elec_usage(line) ->
          Map.put(acc, :day_elec_usage, parse_day_elec_usage(line))

        start?(line) ->
          dt = parse_timestamp(line)
          Map.put(acc, :timestamp, dt)

        true ->
          acc
      end
    end)
  end

  def store_chunk(chunk) do
    # Gas
    params = %{"value" => chunk.gas, "read_on" => chunk.timestamp}
    Homedash.Data.insert_gas(params)

    params = %{
      "value" => chunk.day_elec_inject + chunk.night_elec_inject,
      "read_on" => chunk.timestamp
    }

    Homedash.Data.insert_solar(params)

    params = %{
      "value" => chunk.day_elec_usage + chunk.night_elec_usage,
      "read_on" => chunk.timestamp
    }

    Homedash.Data.insert_electricity(params)

    nil
  end

  def valid_chunk?(chunk) do
    Map.keys(chunk)
    |> MapSet.new()
    |> MapSet.equal?(
      MapSet.new([
        :day_elec_inject,
        :day_elec_usage,
        :gas,
        :night_elec_inject,
        :night_elec_usage,
        :timestamp
      ])
    )
  end

  def parse(file) do
    File.stream!(file)
    |> Stream.map(fn line ->
      String.replace(line, "CEST", "Europe/Brussels")
      |> String.trim()
    end)
    |> Stream.filter(&wanted?/1)
    |> Stream.transform([], fn line, chunk ->
      # if we encounted a datestamp we start a new chunk.
      if start?(line) do
        if chunk != [] do
          {[chunk], [line]}
        else
          {[], [line]}
        end
      else
        {[], [line | chunk]}
      end
    end)
    |> Stream.map(&parse_chunk/1)
    |> Stream.filter(&valid_chunk?/1)
    |> Stream.map(&store_chunk/1)
    |> Enum.to_list()
  end
end
