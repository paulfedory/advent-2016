defmodule Triangle do

  def process do
    File.open("input.txt")
    |> read_from_file
    |> split_lines
    |> split_instructions([])
    |> do_transpose
    |> start_counting
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
    number_line = String.split(head)
    |> Enum.map(&String.to_integer/1)
    split_instructions(tail, [ number_line | accumulator ])
  end

  def start_counting(array, triangle_count \\ 0)
  def start_counting([], t), do: t
  def start_counting([head | tail], triangle_count) do
    if possible_triangle(head) do
      start_counting(tail, triangle_count + 1)
    else
      start_counting(tail, triangle_count)
    end
  end

  def possible_triangle([x, y, z]) do
    if x + y > z && y + z > x && x + z > y do
      true
    else
      false
    end
  end

  def do_transpose(array, accumulator \\ [])
  def do_transpose([], accumulator), do: accumulator
  def do_transpose(array, accumulator) do
    {first, second} = Enum.split(array, 3)
    do_transpose(second, accumulator ++ transpose(first))
  end

  def transpose([[]|_]), do: []
  def transpose(a) do
    [Enum.map(a, &hd/1) | transpose(Enum.map(a, &tl/1))]
  end

end
