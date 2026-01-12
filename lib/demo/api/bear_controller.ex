defmodule Demo.Api.BearController do
  def index(conv) do
    json =
      Demo.Wildthings.list_bears()
    |> Poison.encode!

    %{conv | status_code: 200, resp_body: json}
  end
end
