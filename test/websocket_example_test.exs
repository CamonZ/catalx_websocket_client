defmodule WebsocketExampleTest do
  use ExUnit.Case
  doctest WebsocketExample

  test "greets the world" do
    assert WebsocketExample.hello() == :world
  end
end
