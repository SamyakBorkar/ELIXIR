defmodule Demo.Plugins do
  def track(%{path: path, status_code: 404} = conv) do
    IO.puts("Warning #{path} is on loose!")
    conv
  end

  def track(conv), do: conv

  # route rewriting is done here if anyone is hiting with a wildlife route he will be rerouted to wildthing route
  def route_rewriting(%{path: "/wildlife"} = conv) do
    %{conv | path: "/wildthings"}
  end

  def route_rewriting(conv), do: conv
  # value of print ke saath saath return bhi krta h ye
  def log(conv), do: IO.inspect(conv)
end
