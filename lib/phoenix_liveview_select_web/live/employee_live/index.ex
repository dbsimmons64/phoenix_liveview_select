defmodule PhoenixLiveviewSelectWeb.EmployeeLive.Index do
  use PhoenixLiveviewSelectWeb, :live_view

  alias PhoenixLiveviewSelectWeb.Live.Components.Select
  alias PhoenixLiveviewSelect.Countries

  @category_options [%{text: "foo"}, %{text: "boo"}, %{text: "woo"}]
  @impl true
  def render(assigns) do
    ~H"""
    <.header>Create Employee</.header>

    <.simple_form for={@form} id="employee-form" phx-change="validate" phx-submit="save">
      <.input name="name" label="Name" field={@form[:name]} />

      <.live_component
        field={@form[:country]}
        id={@form[:country].id}
        module={Select}
        autocomplete="autocomplete_countries"
        label="Country"
        options={@countries_options}
      >
        <:option :let={country}>
          <img src={Countries.country_image(country)} class="w-6 h-6 mx-2" />
          <%= country.text %>
        </:option>
      </.live_component>

      <.live_component
        field={@form[:category]}
        id={@form[:category].id}
        module={Select}
        autocomplete="autocomplete_category"
        label="Category"
        options={@category_options}
      >
        <:option :let={category}>
          <%= category.text %>
        </:option>
      </.live_component>

      <.button type="submit">Save</.button>
    </.simple_form>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(form: to_form(%{}))
      |> update_countries_options()
      |> assign(category_options: @category_options)

    {:ok, socket}
  end

  @impl true
  def handle_event("validate", employee_params, socket) do
    socket =
      socket |> assign(form: to_form(employee_params))

    {:noreply, socket}
  end

  def handle_event("save", employee_params, socket) do
    dbg(employee_params)

    socket =
      socket
      |> assign(form: to_form(employee_params))
      |> put_flash(:info, "Success: #{inspect(employee_params)}")

    {:noreply, socket}
  end

  def handle_event("autocomplete_countries", %{"query" => query}, socket) do
    dbg(query)
    {:noreply, update_countries_options(socket, query)}
  end

  def handle_event("autocomplete_category", %{"query" => query}, socket) do
    {:noreply, socket}
  end

  defp update_countries_options(socket, query \\ "") do
    options =
      PhoenixLiveviewSelect.Countries.search_countries(query)
      |> Enum.map(fn country ->
        Map.merge(country, %{id: country.code, text: country.name})
      end)

    assign(socket, countries_options: options)
  end
end
