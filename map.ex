data = [
  %{1 => 433187, 2 => 0},
  %{1 => 433186, 2 => 0}
]

s = 433187

new_data =
  Enum.map(data, fn x ->
    case x do
      %{1 => ^s} -> x
    end
  end)

IO.inspect(new_data)
IO.inspect(data)
