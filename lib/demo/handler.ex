defmodule Demo.Handler do
  import Demo.Parser, only: [parse: 1]
  import Demo.Plugins, only: [route_rewriting: 1, track: 1, log: 1]

  #Module Attributes
  @file_path Path.expand("../../pages", __DIR__)

  def handle(request) do
    request
    |> parse
    |> route_rewriting
    |> log
    |> route
    |> track
    |> format_response
  end

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

  def route(%{method: "GET", path: "/bears" <> id} = conv) do
    %{conv | status_code: 200, resp_body: "Bear #{id}"}
  end

  def route(%{method: "GET", path: "/about"} = conv) do
    @file_path
    |> Path.join("about.html")
    |> File.read()
    |> handleFile(conv)
  end

  def route(%{path: path} = conv) do
    %{conv | status_code: 404, resp_body: "No #{path} Here !"}
  end

  def handleFile({:ok, content}, conv) do
    %{conv | status_code: 200, resp_body: content}
  end

  def handleFile({:error, :enoent}, conv) do
    %{conv | status_code: 404, resp_body: "File Not Found"}
  end

  def handleFile({:error, reason}, conv) do
    %{conv | status_code: 500, resp_body: "File Error #{reason}"}
  end

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

request = """
GET /about HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Demo.Handler.handle(request)
IO.puts(response)
