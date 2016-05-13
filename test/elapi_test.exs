defmodule ElapiTest do
  use ExUnit.Case
  doctest Elapi

  test "the truth" do
    assert 1 + 1 == 2
  end
end


defmodule ElapiRakeRouteTest do
  defmodule HasA do
    use ExUnit.Case

    def blank_route, do: %Elapi.RakeRoute{}

    test "prefix",            do: assert blank_route.prefix === ""
    test "verb",              do: assert blank_route.verb === "GET"
    test "uri_pattern",       do: assert blank_route.uri_pattern === ""
    test "controller_action", do: assert blank_route.controller_action === ""
  end
end


defmodule ElapiValidTest do
  use ExUnit.Case
  def blank_route, do: %Elapi.RakeRoute{}

  test "Integers are valid", do: assert Elapi.valid?(5)

  test "Default RakeRoute is invalid", do: assert Elapi.invalid?(blank_route)

  test "RakeRoute w/ good data in all fields is valid" do
    route = %Elapi.RakeRoute{
      prefix: "projects",
      verb: "POST",
      uri_pattern: "/projects(.:format)",
      controller_action: "projects#create"
    }
    assert Elapi.valid?(route)
  end

  test "Rejects invalid verb" do
    route = %Elapi.RakeRoute{
      prefix: "projects",
      verb: "HOP",
      uri_pattern: "/projects(.:format)",
      controller_action: "projects#create"
    }
    assert Elapi.invalid?(route)
  end

  test "Rejects badly formatted controller_action" do
    route = %Elapi.RakeRoute{
      prefix: "projects",
      uri_pattern: "/projects(.:format)",
      controller_action: "projects"
    }
    assert Elapi.invalid?(route)
  end

  test "Rejects badly formatted URI pattern" do
    route = %Elapi.RakeRoute{
      prefix: "projects",
      uri_pattern: "projects(.:format)",
      controller_action: "projects#create"
    }
    assert Elapi.invalid?(route)
  end
end
