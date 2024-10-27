defmodule PhoenixLiveviewSelectWeb.Live.Components.Datalist do
  use PhoenixLiveviewSelectWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div class="relative hidden" id={@id<>"_datalist"}>
      <div class="absolute w-full top-[100%] border border-zinc-300 rounded shadow-md my-1 bg-white ">
        <%= if Enum.empty?(@options) do %>
          <p class="p-2 text-sm">No results</p>
        <% else %>
          <%= for option <- @options do %>
            <div
              class="p-1 cursor-default hover:bg-gray-200 text-sm flex items-center"
              data-id={option}
              data-text={option}
            >
              <%= render_slot(@option, option) %>
            </div>
          <% end %>
        <% end %>
      </div>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    socket = assign(socket, assigns)

    {:ok, socket}
  end
end
