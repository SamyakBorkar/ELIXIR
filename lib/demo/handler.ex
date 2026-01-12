defmodule Demo.Handler do
  import Demo.Parser, only: [parse: 1]
  import Demo.Plugins, only: [route_rewriting: 1, track: 1, log: 1]

  alias Demo.Conv
  alias Demo.BearController
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
  def route(%Conv{method: "GET", path: "/wildthings"} = conv) do
    # %{conv | status_code: 200, resp_body: "Bears, Lions, Tigers"}
    BearController.show(conv)
  end

  # function clauses
  def route(%Conv{method: "GET", path: "/bears"} = conv) do
    # Demo.Api.BearController.index(conv)
    BearController.show(conv)
  end

  def route(%Conv{method: "GET", path: "/bears" <> id} = conv) do
    %{conv | status_code: 200, resp_body: "Bear #{id}"}
  end

  def route(%Conv{method: "GET", path: "/about"} = conv) do
    @file_path
    |> Path.join("about.html")
    |> File.read()
    |> handleFile(conv)
  end

  def route(%Conv{path: path} = conv) do
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

  def format_response(%Conv{} = conv) do
    """
    HTTP/1.1 #{Conv.full_status(conv)}
    Content-Type: text/html
    Content-Length: #{String.length(conv.resp_body)}

    #{conv.resp_body}
    """
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
