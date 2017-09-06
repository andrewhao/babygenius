defmodule Babygenius.AlexaController do
  use Babygenius.Web, :controller
  use PhoenixAlexa.Controller, :command

  def launch_request(conn, request) do
    response = %Response{}
                |> set_output_speech(%TextOutputSpeech{text: "Welcome to Babygenius. What would you like to log today? You can log a feeding, or a diaper change. For help, say Help."}) 

    conn |> set_response(response)
  end
end
