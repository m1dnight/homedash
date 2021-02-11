# Default is to insert a zero value for the beginning of time.
timestamp = ~U[1970-01-01 00:00:00Z]

Homedash.Data.insert_electricity(%{value: 0.0, read_on: timestamp})
Homedash.Data.insert_solar(%{value: 0.0, read_on: timestamp})
Homedash.Data.insert_gas(%{value: 0.0, read_on: timestamp})
