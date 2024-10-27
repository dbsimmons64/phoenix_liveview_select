defmodule PhoenixLiveviewSelectWeb.Live.Components.Select do
  use PhoenixLiveviewSelectWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div phx-feedback-for={@name} phx-hook="Select" autocomplete={@autocomplete} id={@id}>
      <.label for={@id}><%= @label %></.label>

      <div class="relative">
        <div class="relative">
          <input
            type="hidden"
            id={@id <> "_value_input"}
            name={@name}
            value={if @selected, do: @selected.text}
          />

          <input
            form="disabled"
            id={@id <> "_input"}
            type="text"
            autocomplete="off"
            value={if @selected, do: @selected.text}
            class={[
              "mt-2 block w-full rounded-lg text-zinc-900 focus:ring-0 sm:text-sm sm:leading-6",
              "phx-no-feedback:border-zinc-300 phx-no-feedback:focus:border-zinc-400",
              @errors == [] && "border-zinc-300 focus:border-zinc-400",
              @errors != [] && "border-rose-400 focus:border-rose-400"
            ]}
          />

          <div id={@id <> "_loader"} class="absolute right-2 top-0 bottom-0 flex items-center hidden">
            <.icon name="hero-arrow-path" class="block h-4 w-4 animate-spin text-gray-600" />
          </div>
        </div>

        <div
          id={@id <> "_select"}
          class="absolute w-full top-[100%] border border-zinc-300 rounded shadow-md my-2 bg-white hidden"
        >
          <div class="relative max-h-[200px] overflow-y-auto py-1 bg-white z-10">
            <%= if Enum.empty?(@options) do %>
              <p class="p-2 text-sm">No results</p>
            <% else %>
              <%= for option <- @options do %>
                <div
                  class="p-1 cursor-default hover:bg-gray-200 text-sm flex items-center"
                  data-text={option.text}
                >
                  <%= render_slot(@option, option) %>
                </div>
              <% end %>
            <% end %>
          </div>
        </div>
      </div>

      <.error :for={msg <- @errors}><%= msg %></.error>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    %{field: field} = assigns

    socket =
      socket
      |> assign(assigns)
      |> assign(id: assigns.id || field.id)
      |> assign(:errors, Enum.map(field.errors, &translate_error(&1)))
      |> assign_new(:name, fn -> field.name end)

    selected = Enum.find(socket.assigns.options, &(&1.text == field.value))

    socket = assign(socket, :selected, selected)

    {:ok, socket}
  end
end
