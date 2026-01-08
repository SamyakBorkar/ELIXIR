defmodule Demo.Handler do
  def handle(request) do
    request
    |> parse
    |> route_rewriting
    |> log
    |> route
    |> track
    |> format_response
  end

  def parse(request) do
    [method, path, _] =
      request
      |> String.split("\n")
      |> List.first()
      |> String.split(" ")

    %{method: method, path: path, resp_body: "", status_code: nil}
  end

  # route rewriting is done here if anyone is hiting with a wildlife route he will be rerouted to wildthing route
  def route_rewriting(%{path: "/wildlife"} = conv) do
    %{conv | path: "/wildthings"}
  end

  def route_rewriting(conv), do: conv
  # value of print ke saath saath return bhi krta h ye
  def log(conv), do: IO.inspect(conv)

  # def route(conv) do
  #   route(conv, conv.method, conv.path)
  # end

  # function clauses
  def route(%{method: "GET", path: "/wildthings"} = conv) do
    %{conv | status_code: 200, resp_body: "Bears, Lions, Tigers"}
  end

  # function clauses
  def route(%{method: "GET", path: "/bears"} = conv) do
    %{conv | status_code: 200, resp_body: "EENA, MEENA, DEKKA"}
  end

  def route(%{method: "GET", path: "/bears"<>id} = conv) do
    %{conv | status_code: 200, resp_body: "Bear #{id}"}
  end

  def route(%{path: path} = conv) do
    %{conv | status_code: 404, resp_body: "No #{path} Here !"}
  end

  def track(%{path: path, status_code: 404} = conv) do
    IO.puts("Warning #{path} is on loose!")
    conv
  end

  def track(conv), do: conv

  def format_response(conv) do
    body = conv.resp_body
    response_code = conv.status_code

    """
    HTTP/1.1 #{response_code} #{status_reason(response_code)}
    Content-Type: text/html
    Content-Length: #{String.length(body)}

    #{body}
    """
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

request = """
GET /wildthings HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Demo.Handler.handle(request)
IO.puts(response)

request = """
GET /bears HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Demo.Handler.handle(request)
IO.puts(response)

request = """
GET /unicorn HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Demo.Handler.handle(request)
IO.puts(response)

request = """
GET /bears/1 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Demo.Handler.handle(request)
IO.puts(response)

request = """
GET /wildlife HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Demo.Handler.handle(request)
IO.puts(response)
