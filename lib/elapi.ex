defmodule Elapi do
  alias Elapi.StringUtil

  defmodule RakeRoute do
    defstruct prefix: "", verb: "GET", uri_pattern: "", controller_action: ""
  end

  defprotocol Valid do
    @doc "Returns true if data is in a valid state"
    def valid?(data)

    @doc "Returns true if data isn't in a valid state"
    def invalid?(data)
  end

  defimpl Valid, for: Integer do
    def valid?(_), do: true
    def invalid?(data), do: not valid?(data)
  end

  defimpl Valid, for: RakeRoute do
    import StringUtil

    def valid?(route) do
      verb?(route) and
        controller_action?(route) and
        uri_pattern?(route) and
        nonblank?(route.prefix)
    end

    def invalid?(route), do: not valid?(route)

    defp verb?(route) do
      route.verb in ["GET", "DELETE", "PATCH", "POST", "PUT"]
    end

    defp controller_action?(route) do
      text = route.controller_action
      nonblank?(text) and text =~ ~r/^[\w]+#[\w]+$/
    end

    defp uri_pattern?(route) do
      nonblank?(route.uri_pattern) and String.starts_with?(route.uri_pattern, "/")
    end
  end

  def valid?(data),   do: Valid.valid?(data)
  def invalid?(data), do: Valid.invalid?(data)
end
