defmodule PhoenixLiveviewSelect.Countries do
  @countries [
    %{name: "France", code: "FR"},
    %{name: "United States", code: "US"},
    %{name: "United Kingdom", code: "GB"},
    %{name: "Germany", code: "DE"},
    %{name: "Spain", code: "ES"},
    %{name: "Italy", code: "IT"},
    %{name: "Canada", code: "CA"},
    %{name: "Australia", code: "AU"},
    %{name: "Brazil", code: "BR"},
    %{name: "India", code: "IN"},
    %{name: "China", code: "CN"},
    %{name: "Japan", code: "JP"},
    %{name: "Russia", code: "RU"},
    %{name: "South Africa", code: "ZA"},
    %{name: "Nigeria", code: "NG"}
  ]

  def search_countries(name) do
    @countries
    |> Enum.filter(fn country ->
      String.contains?(String.downcase(country.name), String.downcase(name))
    end)
  end

  def country_image(%{code: code}) do
    "https://flagsapi.com/#{code}/flat/64.png"
  end
end
