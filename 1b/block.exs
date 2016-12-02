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
    walk({{0, 0}, MapSet.new([{0,0}])}, array, "NORTH")
  end

  defp walk(t, [], _), do: t
  defp walk({old_coord, m}, [{"L", i} | tail], "NORTH") do
    step({old_coord, m}, "WEST", i) # returns {x-i, y}
    |> walk(tail, "WEST")
  end

  defp walk({old_coord, m}, [{"R", i} | tail], "NORTH") do
    step({old_coord, m}, "EAST", i) # {x+i, y}
    |> walk(tail, "EAST")
  end

  defp walk({old_coord, m}, [{"L", i} | tail], "SOUTH") do
    step({old_coord, m}, "EAST", i) #{x+i, y}
    |> walk(tail, "EAST")
  end

  defp walk({old_coord, m}, [{"R", i} | tail], "SOUTH") do
    step({old_coord, m}, "WEST", i) # {x-i, y}
    |> walk(tail, "WEST")
  end

  defp walk({old_coord, m}, [{"L", i} | tail], "EAST") do
    step({old_coord, m}, "NORTH", i) #{x, y+i}
    |> walk(tail, "NORTH")
  end

  defp walk({old_coord, m}, [{"R", i} | tail], "EAST") do
    step({old_coord, m}, "SOUTH", i) #{x, y-i}
    |> walk(tail, "SOUTH")
  end

  defp walk({old_coord, m}, [{"L", i} | tail], "WEST") do
    step({old_coord, m}, "SOUTH", i) #{x, y-i}
    |> walk(tail, "SOUTH")
  end

  defp walk({old_coord, m}, [{"R", i} | tail], "WEST") do
    step({old_coord, m}, "NORTH", i) #{x, y+i}
    |> walk(tail, "NORTH")
  end

  defp step(t, _, 0), do: t
  defp step({{x,y}, m}, direction = "WEST", i) do
    {x-1, y}
    |> check_set(m)
    |> step(direction, i-1)
  end

  defp step({{x,y}, m}, direction = "EAST", i) do
    {x+1, y}
    |> check_set(m)
    |> step(direction, i-1)
  end

  defp step({{x,y}, m}, direction = "NORTH", i) do
    {x, y+1}
    |> check_set(m)
    |> step(direction, i-1)
  end

  defp step({{x,y}, m}, direction = "SOUTH", i) do
    {x, y-1}
    |> check_set(m)
    |> step(direction, i-1)
  end

  defp check_set(coord, map) do
    IO.inspect map
    if MapSet.member?(map, coord) do
      IO.puts "omg we've been here before!"
      IO.inspect coord
      exit(:shutdown)
    end
    {coord, MapSet.put(map, coord)}
  end
end
