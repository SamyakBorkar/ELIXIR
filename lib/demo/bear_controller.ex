defmodule Demo.BearController do
  alias Demo.Wildthings
  alias Demo.Bear
  defp bear_item(bear) do
    "<li> #{bear.name} - #{bear.type}</li>"
  end
  @spec show(%{:resp_body => any(), :status_code => any(), optional(any()) => any()}) :: %{
          :resp_body => <<_::64, _::_*8>>,
          :status_code => 200,
          optional(any()) => any()
        }
  def show(conv) do
    items =
      Wildthings.list_bears()
      |> Enum.filter(&Bear.is_grizzly/1)
      |> Enum.sort(&Bear.ord_asc_by_name/2)
      |> Enum.map(&bear_item/1)


    %{conv | status_code: 200, resp_body: "<ul> #{items} </ul>"}
  end
end
