defmodule Keypad do
  @pad %{
    0 => %{2 => 1},
    1 => %{1 => 2, 2 => 3, 3 => 4},
    2 => %{0 => 5, 1 => 6, 2 => 7, 3 => 8, 4 => 9},
    3 => %{1 => "A", 2 => "B", 3 => "C"},
    4 => %{2 => "D"},
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
    calc_line({0, 2}, array, [])
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
  def get_new_coord({x, y}, ["U" | tail]) do
    cond do
      is_nil(@pad[y-1][x]) ->
        get_new_coord({x, y}, tail)
      true ->
        get_new_coord({x, y-1}, tail)
    end
  end

  def get_new_coord({x, y}, ["D" | tail]) do
    cond do
      is_nil(@pad[y+1][x]) ->
        get_new_coord({x, y}, tail)
      true ->
        get_new_coord({x, y+1}, tail)
    end
  end

  def get_new_coord({x, y}, ["L" | tail]) do
    cond do
      is_nil(@pad[y][x-1]) ->
        get_new_coord({x, y}, tail)
      true ->
        get_new_coord({x-1, y}, tail)
    end
  end

  def get_new_coord({x, y}, ["R" | tail]) do
    cond do
      is_nil(@pad[y][x+1]) ->
        get_new_coord({x, y}, tail)
      true ->
        get_new_coord({x+1, y}, tail)
    end
  end
end
