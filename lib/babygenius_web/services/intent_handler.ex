defprotocol BabygeniusWeb.IntentHandler.HasDependencies do
  @type t :: %{get: fun()}

  @spec get(any()) :: %{
          create_diaper_change: fun(),
          get_timezone_for_user: fun(),
          find_or_create_user_by_amazon_id: fun(),
          create_feeding: fun(),
          get_last_diaper_change: fun()
        }
  def get(t)
end

defmodule BabygeniusWeb.IntentHandler.LiveDependencies do
  defstruct []
end

defimpl BabygeniusWeb.IntentHandler.HasDependencies,
  for: BabygeniusWeb.IntentHandler.LiveDependencies do
  @locality_client Application.get_env(:babygenius, :locality_client)
  @identity_client Application.get_env(:babygenius, :identity_client)
  @baby_life_client Application.get_env(:babygenius, :baby_life_client)

  def get(_t) do
    %{
      create_diaper_change: &Babygenius.BabyLife.create_diaper_change/6,
      get_timezone_for_user: &@locality_client.get_timezone_for_user/1,
      find_or_create_user_by_amazon_id: &@identity_client.find_or_create_user_by_amazon_id/1,
      create_feeding: &@baby_life_client.create_feeding/2,
      get_last_diaper_change: &@baby_life_client.get_last_diaper_change/1
    }
  end
end

defmodule BabygeniusWeb.IntentHandler do
  @moduledoc """
    Service module to handle incoming intents from Alexa Skills Kit
  """
  use Timex
  alias BabygeniusWeb.IntentHandler.{LiveDependencies, HasDependencies}
  alias Babygenius.{BabyLife, Identity, TimeUtils}
  use BabygeniusWeb, :model

  @spec handle_intent(
          clause :: String.t(),
          request :: map(),
          now :: DateTime.t(),
          dependencies :: HasDependencies.t()
        ) :: map()
  def handle_intent(
        clause,
        request,
        now \\ Timex.now(),
        dependencies \\ %LiveDependencies{}
      ) do
    deps = HasDependencies.get(dependencies)

    with user <-
           find_or_create_user_from_request(
             request,
             deps
           ),
         user_local_timezone <- deps.get_timezone_for_user.(user.id) do
      handle_intent_with_user_and_timezone(
        clause,
        request,
        now,
        user,
        user_local_timezone,
        deps
      )
    end
  end

  def handle_intent_with_user_and_timezone(
        "GetLastDiaperChange",
        _request,
        now,
        user,
        user_local_timezone,
        dependencies
      ) do
    dependencies.get_last_diaper_change.(user)
    |> last_diaper_change_text(user_local_timezone, now)
    |> (&%{speak_text: &1, should_end_session: true}).()
  end

  def handle_intent_with_user_and_timezone(
        "AddDiaperChange",
        request,
        now,
        user,
        user_local_timezone,
        dependencies
      ) do
    diaper_change_from_request(
      user,
      request,
      user_local_timezone,
      now,
      dependencies.create_diaper_change
    )
    |> add_diaper_change_speech(user_local_timezone, now)
    |> (&%{speak_text: &1, should_end_session: true}).()
  end

  def handle_intent_with_user_and_timezone(
        "AddFeeding",
        request,
        now,
        user,
        user_local_timezone,
        dependencies
      ) do
    request
    |> extract_params_from_feeding_request(user)
    |> dependencies.create_feeding.(now)
    |> case do
      {:ok, feeding} ->
        feeding
        |> feeding_created_speech(user_local_timezone, now)

      {:error, _} ->
        "Uh oh"
    end
    |> (&%{speak_text: &1, should_end_session: true}).()
  end

  @spec feeding_created_speech(
          feeding :: %BabyLife.Feeding{},
          user_timezone :: String.t(),
          now :: DateTime.t()
        ) :: String.t()
  defp feeding_created_speech(feeding, user_timezone, now) do
    feeding_time =
      feeding
      |> Map.get(:occurred_at)
      |> Timex.Timezone.convert(user_timezone)
      |> TimeUtils.formatted_time(now |> Timex.Timezone.convert(user_timezone))

    "A #{feeding.feed_type} has been logged for #{feeding_time}"
  end

  @spec extract_params_from_feeding_request(request :: map(), user :: %Identity.User{}) :: %{
          user: %Identity.User{},
          feed_type: String.t(),
          volume: integer() | nil,
          unit: String.t() | nil,
          time: String.t() | nil,
          date: String.t() | nil
        }
  defp extract_params_from_feeding_request(request, user) do
    slots = request.request.intent.slots |> Morphix.atomorphiform!()
    feed_type = get_in(slots, [:feedName, :value])
    date = get_in(slots, [:feedDate, :value])
    time = get_in(slots, [:feedTime, :value])
    unit = get_in(slots, [:volumeUnit, :value])
    volume = get_in(slots, [:amount, :value])

    %{user: user, feed_type: feed_type, volume: volume, unit: unit, time: time, date: date}
  end

  @spec extract_device_params_from_request(request :: map()) :: %{
          device_id: String.t(),
          consent_token: String.t()
        }
  defp extract_device_params_from_request(request) do
    %{
      context: %{
        System: %{
          device: %{deviceId: device_id},
          user: %{
            permissions: %{
              consentToken: consent_token
            }
          }
        }
      }
    } = request

    %{device_id: device_id, consent_token: consent_token}
  end

  @spec last_diaper_change_text(
          diaper_change :: %BabyLife.DiaperChange{} | nil,
          user_timezone :: String.t(),
          now :: DateTime.t()
        ) :: String.t()
  defp last_diaper_change_text(nil, _user_timezone, _now) do
    "You have not logged any diaper changes yet"
  end

  defp last_diaper_change_text(diaper_change, user_timezone, now) do
    change_time =
      diaper_change
      |> Map.get(:occurred_at)
      |> Timex.Timezone.convert(user_timezone)
      |> TimeUtils.formatted_time(now |> Timex.Timezone.convert(user_timezone))

    "The last diaper change occurred #{change_time}"
  end

  @spec find_or_create_user_from_request(
          request :: map(),
          dependencies :: BabygeniusWeb.IntentHandler.HasDependencies.t()
        ) :: %Identity.User{}
  defp find_or_create_user_from_request(request, dependencies) do
    user_amazon_id = request.session.user.userId

    extract_device_params_from_request(request)
    |> Map.merge(%{amazon_id: user_amazon_id})
    |> (&struct(Identity.User, &1)).()
    |> dependencies.find_or_create_user_by_amazon_id.()
  end

  @spec diaper_change_from_request(
          user :: %Identity.User{},
          request :: map(),
          user_timezone :: String.t(),
          now :: DateTime.t(),
          create_diaper_change :: fun()
        ) :: %BabyLife.DiaperChange{}
  defp diaper_change_from_request(
         user,
         request,
         user_timezone,
         now,
         create_diaper_change
       ) do
    slots = request.request.intent.slots
    diaper_type = get_in(slots, ["diaperType", "value"])
    fetched_diaper_change_date = get_in(slots, ["diaperChangeDate", "value"])
    fetched_diaper_change_time = get_in(slots, ["diaperChangeTime", "value"])

    create_diaper_change.(
      user,
      diaper_type,
      fetched_diaper_change_time,
      fetched_diaper_change_date,
      user_timezone,
      now
    )
  end

  @spec add_diaper_change_speech(
          diaper_change :: %BabyLife.DiaperChange{},
          user_timezone :: String.t(),
          now :: DateTime.t()
        ) :: String.t()
  defp add_diaper_change_speech(diaper_change, user_timezone, now) do
    time =
      diaper_change.occurred_at
      |> Timex.Timezone.convert(user_timezone)
      |> TimeUtils.formatted_time(now |> Timex.Timezone.convert(user_timezone))

    "A #{diaper_change.type} diaper change was logged #{time}"
  end
end