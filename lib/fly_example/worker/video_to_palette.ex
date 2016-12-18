defmodule FlyExample.Worker.VideoToPalette do
  @moduledoc """
  VideoToPalette is a Fly Worker that converts a video file into a `.png` file
  representing its palette, via `ffmpeg`, and returns the `.png` content.
  """

  @doc """
  Turns an video into a `.png` palette.
  """
  def call(input, _config) do
    # We have to generate a file to work with sadly, because ffmpeg doesn't
    # handle piping mp4 files so well unless they're generated with `-movflags
    # +faststart`
    input_file =
      with {path, _} <- System.cmd("mktemp", []),
        do: String.strip(path)
    File.write!(input_file, input)

    output_file_root =
      with {path, _} <- System.cmd("mktemp", []),
        do: String.strip(path)
    output_file = "#{output_file_root}.png"

    %Porcelain.Result{out: output, status: status} =
      Porcelain.exec("ffmpeg",
                     [
                       "-ss",
                       "0", # starting point
                       "-t",
                       "10", # num seconds
                       "-i",
                       input_file,
                       "-vf",
                       "fps=15,scale=320:-1:flags=lanczos,palettegen",
                       "-y",
                       output_file,
                     ])

    File.read!(output_file)
  end
end
