defmodule Block do

  def process do
    File.open("input.txt")
    |> read_from_file
    |> split_commas
    |> split_instructions
    |> start_counting
    |> IO.inspect
  end

  def read_from_file({:ok, file}) do
    IO.read(file, :line)
  end

  def read_from_file({_, error}) do
    IO.puts "Error: #{:file.format_error(error)}"
  end

  def split_commas(line) do
    String.split(line, ", ")
  end

  def split_instructions(array) do
    array
    |> Enum.map(fn(x) -> String.split_at(x, 1) end)
    |> Enum.map(fn({x, y}) -> {x, elem(Integer.parse(y), 0)} end)
  end

  def start_counting(array) do
    count(array, {0, 0, "NORTH"})
  end

  defp count([], t), do: t
  defp count([{"L", i} | tail], {x, y, "NORTH"}) do
    count(tail, {x-i, y, "WEST"})
  end

  defp count([{"R", i} | tail], {x, y, "NORTH"}) do
    count(tail, {x+i, y, "EAST"})
  end

  defp count([{"L", i} | tail], {x, y, "SOUTH"}), do: count(tail, {x+i, y, "EAST"})
  defp count([{"R", i} | tail], {x, y, "SOUTH"}), do: count(tail, {x-i, y, "WEST"})
  defp count([{"L", i} | tail], {x, y, "EAST"}), do: count(tail, {x, y+i, "NORTH"})
  defp count([{"R", i} | tail], {x, y, "EAST"}), do: count(tail, {x, y-i, "SOUTH"})
  defp count([{"L", i} | tail], {x, y, "WEST"}), do: count(tail, {x, y-i, "SOUTH"})
  defp count([{"R", i} | tail], {x, y, "WEST"}), do: count(tail, {x, y+i, "NORTH"})

end
