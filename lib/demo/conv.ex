defmodule Demo.Conv do
  defstruct method: "", path: "", resp_body: "", status_code: nil

  def full_status(conv) do
    "#{conv.status_code} #{status_reason(conv.status_code)}"
  end

  defp status_reason(code) do
    %{
      200 => "OK",
      201 => "CREATED",
      401 => "UNAUTHORIZED",
      404 => "NOT FOUND",
      500 => "INTERNAL SERVER ERROR"
    }[code]
  end
end
