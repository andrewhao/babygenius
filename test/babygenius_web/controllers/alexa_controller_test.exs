defmodule Babygenius.AlexaControllerTest do
  use BabygeniusWeb.ConnCase, async: true
  use BabygeniusWeb, :model
  use Timex

  import Mox

  alias Babygenius.{RequestFixtures, AddFeedingRequestFixture}
  alias Babygenius.BabyLife.DiaperChange

  setup do
    Babygenius.Locality.Mock
    |> stub(:trigger_zipcode_lookup, fn _, _ -> {:ok, "pid"} end)
    |> stub(:get_timezone_for_user, fn _ -> "America/Los_Angeles" end)

    Babygenius.Identity.Mock
    |> stub(:find_or_create_user_by_amazon_id, fn _user -> insert(:user) end)

    {:ok, pass: "pass"}
  end

  describe "GetLastDiaperChange intent_request/3" do
    setup do
      user = insert(:user, amazon_id: RequestFixtures.amazon_id())

      # Insert a previous diaper change at 8:00AM today
      insert(
        :diaper_change,
        user: user,
        occurred_at: Timex.now() |> Timex.set(month: 12, day: 15, hour: 10, minute: 5)
      )

      request =
        build_conn()
        |> put_req_header("accept", "application/json")
        |> put_req_header("content-type", "application/json")

      Babygenius.Identity.Mock
      |> stub(:find_or_create_user_by_amazon_id, fn _user -> user end)

      {:ok, request: request, json: RequestFixtures.get_last_diaper_change_json()}
    end

    test "it responds with confirmation text", %{request: request, json: json} do
      response =
        request
        |> post(alexa_path(build_conn(), :command), json)
        |> json_response(200)

      expected_text = "The last diaper change occurred December 15th at 2:05 AM"

      assert get_in(response, ["response", "outputSpeech", "text"]) == expected_text
    end
  end

  describe "AddDiaperChange intent_request/3" do
    setup do
      request =
        build_conn()
        |> put_req_header("accept", "application/json")
        |> put_req_header("content-type", "application/json")

      {:ok, request: request, json: RequestFixtures.add_diaper_change_json()}
    end

    test "responds with shouldEndSession true", %{request: request, json: json} do
      response =
        request
        |> post(alexa_path(build_conn(), :command), json)
        |> json_response(200)

      assert response["response"]["shouldEndSession"] == true
    end

    test "adds a DiaperChange record into the DB", %{request: request, json: json} do
      old_count = Repo.aggregate(from(dc in "diaper_changes"), :count, :id)

      request
      |> post(alexa_path(build_conn(), :command), json)
      |> json_response(200)

      new_count = Repo.aggregate(from(dc in "diaper_changes"), :count, :id)
      assert old_count == new_count - 1
    end

    test "it creates a new user if one does not already exist", %{request: request, json: json} do
      old_count = Repo.aggregate(from(dc in "users"), :count, :id)

      request
      |> post(alexa_path(build_conn(), :command), json)
      |> json_response(200)

      new_count = Repo.aggregate(from(dc in "users"), :count, :id)
      assert old_count == new_count - 1
    end

    test "logs a DiaperChange with the right type", %{request: request, json: json} do
      _response =
        request
        |> post(alexa_path(build_conn(), :command), json)
        |> json_response(200)

      type =
        DiaperChange
        |> last
        |> Repo.one()
        |> Map.fetch!(:type)

      assert type == "wet"
    end

    test "it responds with confirmation text", %{request: request, json: json} do
      response =
        request
        |> post(alexa_path(build_conn(), :command), json)
        |> json_response(200)

      assert get_in(response, ["response", "outputSpeech", "text"]) ==
               "A wet diaper change was logged September 8th at 3:00 AM"
    end
  end

  describe "launch_request/2" do
    test "responds with initial launch text" do
      json = RequestFixtures.launch_request_json()

      response =
        build_conn()
        |> put_req_header("accept", "application/json")
        |> put_req_header("content-type", "application/json")
        |> post(alexa_path(build_conn(), :command), json)
        |> json_response(200)

      assert response["response"]["outputSpeech"]["text"] ==
               "Welcome to Babygenius. What would you like to log today? You can log a feeding, or a diaper change. For help, say Help."

      assert response["response"]["shouldEndSession"] == false
    end
  end

  describe "AddFeeding intent_request/3" do
    setup do
      insert(:user, amazon_id: AddFeedingRequestFixture.amazon_id())

      request =
        build_conn()
        |> put_req_header("accept", "application/json")
        |> put_req_header("content-type", "application/json")

      occurred_at = Timex.now() |> Timex.set(month: 12, day: 25, hour: 12, minute: 0)
      feeding = insert(:feeding, occurred_at: occurred_at)

      Babygenius.BabyLife.Mock
      |> expect(:create_feeding, fn _, _ -> {:ok, feeding} end)

      {:ok, request: request, json: AddFeedingRequestFixture.as_json()}
    end

    test "responds with shouldEndSession true", %{request: request, json: json} do
      response =
        request
        |> post(alexa_path(build_conn(), :command), json)
        |> json_response(200)

      assert response["response"]["shouldEndSession"] == true
    end

    test "responds with confirmation text", %{request: request, json: json} do
      response =
        request
        |> post(alexa_path(build_conn(), :command), json)
        |> json_response(200)

      assert get_in(response, ["response", "outputSpeech", "text"]) ==
               "A bottle has been logged for December 25th at 4:00 AM"
    end
  end
end