defmodule FlyExample.Worker.TextImage do
  @moduledoc """
  TextImage is a Fly worker to generate a text image.
  """

  @doc """
  Generates an image for the provided text
  """
  def call(_input, %{caption: caption}) do
    %Porcelain.Result{out: output, status: status} =
      Porcelain.exec("convert", [
                       "-background", "blue",
                       "-fill", "white",
                       "-font", "Impact",
                       "-size", "640x100",
                       "-gravity", "North",
                       "-stroke", "black",
                       "-strokewidth", "3",
                       "caption:#{String.upcase caption}",
                       "png:-"], [out: :string])

    output
  end
end
