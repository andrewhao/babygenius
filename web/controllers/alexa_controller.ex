defmodule Babygenius.AlexaController do
  use Babygenius.Web, :controller
  use PhoenixAlexa.Controller, :command
  use Timex

  alias Babygenius.DiaperChange

  def launch_request(conn, _request) do
    response = %Response{}
                |> set_output_speech(%TextOutputSpeech{text: "Welcome to Babygenius. What would you like to log today? You can log a feeding, or a diaper change. For help, say Help."}) 

    conn |> set_response(response)
  end

  def intent_request(conn, "AddDiaperChange", request) do
    user_amazon_id = request.session.user.userId
    slots = request.request.intent.slots
    diaper_type = get_in(slots, ["diaperType", "value"])
    occurred_at = Timex.now()

    user = %Babygenius.User{amazon_id: user_amazon_id} |> Babygenius.User.find_or_create_by_amazon_id()
    %DiaperChange{
      user_id: user.id,
      type: diaper_type,
      occurred_at: occurred_at
    }
    |> Repo.insert!

    speak_time = Timex.now() |> Timex.format!("{relative}", :relative)

    response = %Response{}
    |> set_output_speech(%TextOutputSpeech{text: "A #{diaper_type} diaper change was logged #{speak_time}"})
    |> set_should_end_session(true)

    conn |> set_response(response)
  end
end
