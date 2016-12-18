defmodule FlyExample.Worker.Meme do
  require Logger

  @moduledoc """
  Meme is a sweet Fly worker to generate a meme image.
  """

  @doc """
  Generates an image for the provided text
  """
  def call(input, %{top: top, bottom: bottom}) do
    first =
      Porcelain.exec("convert", [
                       "-background", "none",
                       "-fill", "white",
                       "-font", "Impact",
                       "-size", "640x100",
                       "-gravity", "center",
                       "-stroke", "black",
                       "-strokewidth", "3",
                       "caption:#{String.upcase top}",
                       "-",
                       "+swap",
                       "-gravity", "north",
                       "-resize", "640x",
                       "-composite",
                       "-",
                       ], [in: input, out: :string, err: :string])

    case first do
      %Porcelain.Result{out: input_with_top, status: 0} ->
        second =
          Porcelain.exec("convert", [
                           "-background", "none",
                           "-fill", "white",
                           "-font", "Impact",
                           "-size", "640x100",
                           "-gravity", "center",
                           "-stroke", "black",
                           "-strokewidth", "3",
                           "caption:#{String.upcase bottom}",
                           "-",
                           "+swap",
                           "-gravity", "south",
                           "-composite",
                           "-",
                           ], [in: input_with_top, out: :string])
        case second do
          %Porcelain.Result{out: output, status: 0} ->
            output
          %Porcelain.Result{status: _, err: err} ->
            Logger.error err
        end
      %Porcelain.Result{status: _, err: err} ->
        Logger.error err
    end
  end

  defp get_temp_file do
    with {path, _} <- System.cmd("mktemp", []),
      do: String.strip(path)
  end
end
