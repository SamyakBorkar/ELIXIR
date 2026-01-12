defmodule DemoTest do
  use ExUnit.Case
  doctest Demo

  test "check assertion" do
    assert 1 + 1 == 2
  end
end
