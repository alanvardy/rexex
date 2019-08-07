defmodule RexexWeb.RegexLive do
  @moduledoc "Shows live regex results"
  use Phoenix.LiveView
  import Phoenix.HTML.Form
  alias RexexWeb.LiveView
  alias Rexex.Expression

  def render(assigns) do
    LiveView.render("index.html", assigns)
  end

  def mount(_session, socket) do
    assigns = Expression.get_assigns()
    socket = do_assigns(socket, assigns)

    {:ok, socket}
  end

  def handle_event("activate", params, socket) do
    updates = Expression.get_updates(params)
    socket = do_updates(socket, updates)

    {:noreply, socket}
  end

  defp do_assigns(socket, []), do: socket

  defp do_assigns(socket, [{key, value} | tail]) do
    new_value =
      case key do
        key when key in [:string, :regex] -> value
        _ -> Expression.convert(value)
      end

    do_assigns(assign(socket, key, new_value), tail)
  end

  defp do_updates(socket, []), do: socket
  defp do_updates(socket, [:error | _tail]), do: socket

  defp do_updates(socket, [{key, value} | tail]) do
    new_value =
      case key do
        key when key in [:string, :regex] -> value
        _ -> Expression.convert(value)
      end

    do_updates(update(socket, key, fn _x -> new_value end), tail)
  end
end
