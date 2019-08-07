defmodule Rexex.Expression do
  @moduledoc """
  Handles Regex functions for live view
  """
  def get_assigns do
    [
      {:string, ""},
      {:regex, ""},
      {:run, nil},
      {:match?, "true"},
      {:scan, []},
      {:split, []},
      {:named_captures, nil}
    ]
  end

  def get_updates(%{"regex" => %{"string" => string, "regex" => regex}}) do
    results =
      [:run, :match?, :scan, :split, :named_captures]
      |> Enum.map(fn x -> do_regex(x, regex, string) end)

    [{:string, string}, {:regex, regex} | results]
  end

  def do_regex(function, regex, string) do
    try do
      result = apply(Regex, function, [~r/#{regex}/, string])
      {function, result}
    rescue
      _ -> :error
    end
  end

  def convert(value) when is_map(value) do
    value =
      value
      |> Map.keys()
      |> Enum.map(fn key -> "\"#{key}\" => \"#{value[key]}\"" end)
      |> Enum.join(", ")

    "%{#{value}}"
  end

  def convert(value) when is_list(value) do
    value =
      value
      |> Enum.map(fn x -> "\"#{x}\"" end)
      |> Enum.join(", ")

    "[#{value}]"
  end

  def convert(nil), do: "nil"

  def convert(value), do: "\"#{value}\""
end
