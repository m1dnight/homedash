# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Homedash.Repo.insert!(%Homedash.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

# Create electricity datapoint.
# Read once every minute, increase betwe5 and 30 kWh per day.
alias Homedash.Data.Electricity
alias Homedash.Data

day = "20"
ts = Timex.parse!("Thu #{day} Oct 2020 03:00:00 AM Europe/Brussels", "%a %d %b %Y %I:%M:%S %p %Z", :strftime)
attrs = %{"read_on" => ts, "value" => 100}
Data.insert_electricity(attrs)

ts = Timex.parse!("Thu #{day} Oct 2020 11:00:00 PM Europe/Brussels", "%a %d %b %Y %I:%M:%S %p %Z", :strftime)
attrs = %{"read_on" => ts, "value" => 110}
Data.insert_electricity(attrs)

# day = "21"
# ts = Timex.parse!("Thu #{day} Oct 2020 01:00:00 PM Europe/Brussels", "%a %d %b %Y %I:%M:%S %p %Z", :strftime)
# attrs = %{"read_on" => ts, "value" => 110}
# Data.insert_electricity(attrs)

# ts = Timex.parse!("Thu #{day} Oct 2020 11:00:00 PM Europe/Brussels", "%a %d %b %Y %I:%M:%S %p %Z", :strftime)
# attrs = %{"read_on" => ts, "value" => 120}
# Data.insert_electricity(attrs)

# day = "22"
# ts = Timex.parse!("Thu #{day} Oct 2020 01:00:00 PM Europe/Brussels", "%a %d %b %Y %I:%M:%S %p %Z", :strftime)
# attrs = %{"read_on" => ts, "value" => 130}
# Data.insert_electricity(attrs)

# ts = Timex.parse!("Thu #{day} Oct 2020 11:00:00 PM Europe/Brussels", "%a %d %b %Y %I:%M:%S %p %Z", :strftime)
# attrs = %{"read_on" => ts, "value" => 140}
# Data.insert_electricity(attrs)

# day = "23"
# ts = Timex.parse!("Thu #{day} Oct 2020 01:00:00 PM Europe/Brussels", "%a %d %b %Y %I:%M:%S %p %Z", :strftime)
# attrs = %{"read_on" => ts, "value" => 150}
# Data.insert_electricity(attrs)

# ts = Timex.parse!("Thu #{day} Oct 2020 11:00:00 PM Europe/Brussels", "%a %d %b %Y %I:%M:%S %p %Z", :strftime)
# attrs = %{"read_on" => ts, "value" => 160}
# Data.insert_electricity(attrs)
