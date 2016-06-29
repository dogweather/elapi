defmodule Elapi do
  alias Elapi.StringUtil

  defmodule RakeRoute do
    defstruct prefix: "", verb: "GET", uri_pattern: "", controller_action: ""
  end

  defprotocol Valid do
    @doc "Returns true if data is in a valid state"
    @spec valid?(any) :: boolean
    @dialyzer {:nowarn_function, __protocol__: 1}
    def valid?(data)

    @doc "Returns true if data isn't in a valid state"
    @spec invalid?(any) :: boolean
    def invalid?(data)
  end

  defimpl Valid, for: Integer do
    @spec valid?(integer) :: true
    def valid?(_), do: true

    @spec invalid?(integer) :: false
    def invalid?(data), do: not valid?(data)
  end

  defimpl Valid, for: RakeRoute do
    import StringUtil

    @spec valid?(RakeRoute) :: boolean
    def valid?(route) do
      verb?(route) and
        controller_action?(route) and
        url_pattern?(route) and
        nonblank?(route.prefix)
    end

    @spec invalid?(RakeRoute) :: boolean
    def invalid?(route), do: not valid?(route)

    defp verb?(route) do
      route.verb in ["GET", "DELETE", "PATCH", "POST", "PUT"]
    end

    defp controller_action?(route) do
      text = route.controller_action
      nonblank?(text) and text =~ ~r/^[\w]+#[\w]+$/
    end

    defp url_pattern?(route) do
      nonblank?(route.uri_pattern) and String.starts_with?(route.uri_pattern, "/")
    end
  end

  # Make these easier to use e.g. Elapi.valid?(...) instead of
  # Elapi.Valid.valid?(...) 
  def valid?(data),   do: Valid.valid?(data)
  def invalid?(data), do: Valid.invalid?(data)
end
