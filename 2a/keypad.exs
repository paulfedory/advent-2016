defmodule Keypad do
  @pad %{
    0 => %{0 => 1, 1 => 2, 2 => 3},
    1 => %{0 => 4, 1 => 5, 2 => 6},
    2 => %{0 => 7, 1 => 8, 2 => 9}
  }

  def process do
    File.open("input2.txt")
    |> read_from_file
    |> split_lines
    |> split_instructions([])
    |> start_counting
    |> Enum.map(&get_number/1)
    |> IO.inspect
  end

  def read_from_file({:ok, file}) do
    IO.read(file, :all)
  end

  def read_from_file({_, error}) do
    IO.puts "Error: #{:file.format_error(error)}"
  end

  def split_lines(file) do
    String.split(file, "\n")
    |> List.delete("")
  end

  def split_instructions([], accumulator), do: Enum.reverse(accumulator)
  def split_instructions([head | tail], accumulator) do
    split_instructions(tail, [ String.split(head, "", trim: true) | accumulator ])
  end

  def start_counting(array) do
    calc_line({1,1}, array, [])
  end

  def calc_line(start_coord, [], accumulator), do: Enum.reverse(accumulator)
  def calc_line(start_coord, [head | tail], accumulator) do
    new_coord = get_new_coord(start_coord, head)
    #[ new_coord | accumulator ]
    IO.inspect "line"
    IO.inspect new_coord
    calc_line(new_coord, tail, [ new_coord | accumulator ])
  end

  def get_number({x, y}) do
    @pad[y][x]
  end

  def get_new_coord(coord, []), do: coord
  def get_new_coord({x, y}, ["U" | tail]) when y == 0, do: get_new_coord({x, y}, tail)
  def get_new_coord({x, y}, ["U" | tail]) when y > 0, do: get_new_coord({x, y-1}, tail)
  def get_new_coord({x, y}, ["D" | tail]) when y == 2, do: get_new_coord({x, y}, tail)
  def get_new_coord({x, y}, ["D" | tail]) when y < 2, do: get_new_coord({x, y+1}, tail)
  def get_new_coord({x, y}, ["L" | tail]) when x == 0, do: get_new_coord({x, y}, tail)
  def get_new_coord({x, y}, ["L" | tail]) when x > 0, do: get_new_coord({x-1, y}, tail)
  def get_new_coord({x, y}, ["R" | tail]) when x == 2, do: get_new_coord({x, y}, tail)
  def get_new_coord({x, y}, ["R" | tail]) when x < 2, do: get_new_coord({x+1, y}, tail)

end
