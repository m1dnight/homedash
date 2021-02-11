defmodule Parser do
  ################################################################################
  # Predicates

  def gas_reading?(line), do: String.starts_with?(line, "0-1:24.2.3")
  def elec_in_day?(line), do: String.starts_with?(line, "1-0:1.8.1")
  def elec_in_night?(line), do: String.starts_with?(line, "1-0:1.8.2")
  def elec_out_day?(line), do: String.starts_with?(line, "1-0:2.8.1")
  def elec_out_night?(line), do: String.starts_with?(line, "1-0:2.8.2")
  def timestamp?(line), do: String.contains?(line, " CEST") or String.contains?(line, " CET")
  ################################################################################
  # Parsers

  def parse_gas(line) do
    %{"val" => d} = Regex.named_captures(~r"(?<val>\d+\.\d+)\*m3\)", line)
    {value, _} = Float.parse(d)
    value
  end

  def parse_elec_in_day(line) do
    %{"val" => d} = Regex.named_captures(~r"(?<val>\d+\.\d+)\*kWh\)", line)
    {value, _} = Float.parse(d)
    value
  end

  def parse_elec_in_night(line) do
    %{"val" => d} = Regex.named_captures(~r"(?<val>\d+\.\d+)\*kWh\)", line)
    {value, _} = Float.parse(d)
    value
  end

  def parse_elec_out_day(line) do
    %{"val" => d} = Regex.named_captures(~r"(?<val>\d+\.\d+)\*kWh\)", line)
    {value, _} = Float.parse(d)
    value
  end

  def parse_elec_out_night(line) do
    %{"val" => d} = Regex.named_captures(~r"(?<val>\d+\.\d+)\*kWh\)", line)
    {value, _} = Float.parse(d)
    value
  end

  def parse_timestamp(line) do
    result =
      line
      |> String.replace(" CEST", "")
      |> String.replace(" CET", "")
      |> Timex.parse("%a %d %b %Y %I:%M:%S %p", :strftime)

    case result do
      {:ok, naive} ->
        {:ok, dt} = DateTime.from_naive(naive, "Etc/UTC")
        DateTime.to_iso8601(dt)

      _ ->
        IO.puts("Error parsing `#{inspect(String.trim(line))}`")
        nil
    end
  end

  def post(chunk) do
    HTTPoison
  end
end

[file] = System.argv()
IO.puts("#{DateTime.now!("Etc/UTC") |> DateTime.to_iso8601()} Processing #{file}")

################################################################################
# Main
endpoint = "http://earth.lan:4005"
token = "token"

File.stream!(file)
|> Stream.map(&String.trim/1)
|> Stream.transform(%{}, fn line, chunk ->
  if Parser.timestamp?(line) do
    if chunk == %{} do
      {[], %{:timestamp => line}}
    else
      {[chunk], %{:timestamp => line}}
    end
  else
    res =
      cond do
        Parser.gas_reading?(line) -> Map.merge(%{gas: line}, chunk)
        Parser.elec_in_day?(line) -> Map.merge(%{elec_in_day: line}, chunk)
        Parser.elec_in_night?(line) -> Map.merge(%{elec_in_night: line}, chunk)
        Parser.elec_out_day?(line) -> Map.merge(%{elec_out_day: line}, chunk)
        Parser.elec_out_night?(line) -> Map.merge(%{elec_out_night: line}, chunk)
        true -> chunk
      end

    {[], res}
  end
end)
|> Stream.map(fn chunk ->
  chunk
  |> Map.update(:gas, 0.0, &Parser.parse_gas/1)
end)
|> Stream.map(fn chunk ->
  chunk
  |> Map.update(:elec_in_day, 0.0, &Parser.parse_elec_in_day/1)
end)
|> Stream.map(fn chunk ->
  chunk
  |> Map.update(:elec_in_night, 0.0, &Parser.parse_elec_in_night/1)
end)
|> Stream.map(fn chunk ->
  chunk
  |> Map.update(:elec_out_day, 0.0, &Parser.parse_elec_out_day/1)
end)
|> Stream.map(fn chunk ->
  chunk
  |> Map.update(:elec_out_night, 0.0, &Parser.parse_elec_out_night/1)
end)
|> Stream.map(fn chunk ->
  chunk
  |> Map.update(:timestamp, nil, &Parser.parse_timestamp/1)
end)
|> Stream.filter(fn chunk ->
  chunk.elec_in_day != nil and chunk.elec_in_night != nil and chunk.elec_out_day != nil and
    chunk.elec_out_night != nil and chunk.gas != nil and chunk.timestamp != nil
end)
|> Stream.map(&Map.put(&1, :token, token))
|> Stream.flat_map(fn chunk ->
  gas = %{"value" => chunk.gas, "read_on" => chunk.timestamp, "token" => chunk.token}

  solar = %{
    "value" => chunk.elec_out_day + chunk.elec_out_night,
    "read_on" => chunk.timestamp,
    "token" => chunk.token
  }

  elec = %{
    "value" => chunk.elec_in_day + chunk.elec_in_night,
    "read_on" => chunk.timestamp,
    "token" => chunk.token
  }

  [
    {"#{endpoint}/api/gas", Jason.encode!(gas)},
    {"#{endpoint}/api/solar", Jason.encode!(solar)},
    {"#{endpoint}/api/electricity", Jason.encode!(elec)}
  ]
end)
|> Stream.chunk(1000)
|> Stream.map(fn requests ->
  requests
  |> Enum.map(fn {endpoint, payload} ->
    %{status_code: 200} =
      HTTPoison.post!(endpoint, payload, [{"Content-Type", "application/json"}])
  end)
end)
|> Stream.run()

:ok
