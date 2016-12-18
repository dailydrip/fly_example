defmodule FlyExample.Worker.VideoToGif do
  @moduledoc """
  VideoToPalette is a Fly Worker that converts a video file into a `.png` file
  representing its palette, via `ffmpeg`, and returns the `.png` content.
  """

  require Logger

  @doc """
  Turns an video into a `.png` palette.
  """
  def call(input, _config) do
    # Step 1: Generate the palette

    # We have to generate a file to work with sadly, because ffmpeg doesn't
    # handle piping mp4 files so well unless they're generated with `-movflags
    # +faststart`
    input_file = get_temp_file
    File.write!(input_file, input)

    palette_file_root = get_temp_file
    palette_file = "#{palette_file_root}.png"

    output_file_root = get_temp_file
    output_file = "#{output_file_root}.gif"

    # Actually generate the palette
    palette_result =
      Porcelain.exec("ffmpeg",
                     [
                       "-ss",
                       "0", # starting point
                       "-t",
                       "10", # num seconds
                       "-i",
                       input_file,
                       "-vf",
                       "#{filters},palettegen",
                       "-y",
                       palette_file,
                     ])

    case palette_result do
      %Porcelain.Result{status: 0} -> :ok
      %Porcelain.Result{status: _, err: error} -> Logger.error(error)
    end

    # Step 2: Generate the gif
    gif_result =
      Porcelain.exec("ffmpeg",
                     [
                       "-i",
                       input_file,
                       "-i",
                       palette_file,
                       "-lavfi",
                       "#{filters} [x]; [x][1:v] paletteuse",
                       "-y",
                       output_file,
                     ], [err: :string])

    case gif_result do
      %Porcelain.Result{status: 0} -> :ok
      %Porcelain.Result{status: _, err: error} -> Logger.error(error)
    end

    File.read!(output_file)
  end

  defp get_temp_file do
    with {path, _} <- System.cmd("mktemp", []),
      do: String.strip(path)
  end

  defp filters do
    "fps=15,scale=320:-1:flags=lanczos"
  end
end
