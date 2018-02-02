# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Babygenius.Repo.insert!(%Babygenius.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Babygenius.{Identity, BabyLife}

IO.puts("Inserting user")

user =
  %Identity.User{
    amazon_id: "amz.user.1"
  }
  |> Identity.find_or_create_user_by_amazon_id()

IO.puts("Inserting diaper change")

BabyLife.create_diaper_change(
  user,
  "wet",
  "09:00",
  "2017-01-01",
  "America/Los_Angeles",
  DateTime.utc_now()
)

IO.puts("Inserting feeding")

BabyLife.create_feeding(
  %{
    user: user,
    feed_type: "feeding",
    volume: 60,
    unit: "ml",
    time: "12:00",
    date: "2017-01-01",
    user_timezone: "America/Los_Angeles"
  },
  DateTime.utc_now()
)

IO.puts("Done.")