defmodule RexexWeb.RegexLive do
  use Phoenix.LiveView
  import Phoenix.HTML.Form

  def mount(_session, socket) do
    socket =
      socket
      |> assign(:val, 0)
      |> assign(:string, "")
      |> assign(:regex, "")
      |> assign(:result, "")

    {:ok, socket}
  end

  def handle_event("activate", %{"regex" => %{"string" => string, "regex" => regex}}, socket) do
    socket =
      try do
        result = run_regex(regex, string)

          socket
          |> update(:val, &(&1 + 1))
          |> update(:string, fn _x -> string end)
          |> update(:regex, fn _x -> regex end)
          |> update(:result, fn _x -> result end)

      rescue
          RuntimeError -> socket
      end

    {:noreply, socket}
  end

  def render(assigns) do
    ~L"""
    <div>
      <h1>The count is: <%= @val %>, <%= @result %></h1>


      <%= form_for :regex, "#", [phx_change: :activate], fn f -> %>
        <%= text_input f, :regex, value: @regex %>
        <%= textarea f, :string, value: @string %>
      <% end %>
    </div>
    """
  end

  def run_regex(regex, string) do
    Regex.run(~r/#{regex}/, string)
  end
end
