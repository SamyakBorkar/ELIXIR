defmodule Demo.Handler do
  def handle(request) do
    request
    |> parse
    |> log
    |> route
    |> format_response
  end

  def parse(request) do
    [method, path, _] =
      request
      |> String.split("\n")
      |> List.first()
      |> String.split(" ")

    %{method: method, path: path, resp_body: ""}
  end

  def log(conv), do: IO.inspect(conv) #value of print ke saath saath return bhi krta h ye 

  def route(conv) do
    %{conv | resp_body: "Bears, Lions, Tigers"}
  end

  def format_response(conv) do
    body = conv.resp_body

    """
    HTTP/1.1 200 OK
    Content-Type: text/html
    Content-Length: #{String.length(body)}

    #{body}
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
