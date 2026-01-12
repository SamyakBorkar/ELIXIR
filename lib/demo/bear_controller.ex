defmodule Demo.BearController do
  alias Demo.Wildthings
  alias Demo.Bear
  @template_path Path.expand('../../templates', __DIR__)


  @spec show(%{:resp_body => any(), :status_code => any(), optional(any()) => any()}) :: %{
          :resp_body => <<_::64, _::_*8>>,
          :status_code => 200,
          optional(any()) => any()
        }
  def show(conv) do
    items =
      Wildthings.list_bears()
      |> Enum.sort(&Bear.ord_asc_by_name/2)

      content = @template_path
      |> Path.join("index.eex")
      |> EEx.eval_file(bears: items)


    %{conv | status_code: 200, resp_body: content}
  end
end
