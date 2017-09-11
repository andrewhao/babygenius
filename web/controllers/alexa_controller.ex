defmodule Babygenius.AlexaController do
  use Babygenius.Web, :controller
  use PhoenixAlexa.Controller, :command
  use Timex

  alias Babygenius.{IntentHandler}

  def launch_request(conn, _request) do
    response = %Response{}
                |> set_output_speech(%TextOutputSpeech{text: "Welcome to Babygenius. What would you like to log today? You can log a feeding, or a diaper change. For help, say Help."}) 

    conn |> set_response(response)
  end

  def intent_request(conn, "AddDiaperChange", request) do
    intent_handler_response = IntentHandler.handle_intent("AddDiaperChange", request)

    response = %Response{}
    |> set_output_speech(%TextOutputSpeech{text: intent_handler_response.speak_text})
    |> set_should_end_session(intent_handler_response.should_end_session)

    conn |> set_response(response)
  end
end
