defmodule Elapi.StringUtil do
  def nonblank?(data) when is_bitstring(data), do: String.length(data) > 0
  def blank?(data),   do: not nonblank?(data)
end
