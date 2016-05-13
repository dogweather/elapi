defmodule Elapi.StringUtil do
  def blank?(data),     do: not nonblank?(data)
  def nonblank?(data)  when is_bitstring(data), do: String.length(data) > 0
end
