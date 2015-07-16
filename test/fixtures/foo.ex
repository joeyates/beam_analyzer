defmodule Foo do
  def a_method do
    a_private_method
    "Ciao"
  end

  defp a_private_method do
    "I'm private"
  end
end
