defmodule Repeat do
  def process do
    File.open("input2.txt")
    |> read_from_file
    |> split_lines
    |> build_map
    |> sort_maps([])
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

  def build_map(array_of_strings, list_of_maps \\ [%{}, %{}, %{}, %{}, %{}, %{}, %{}, %{}])
  def build_map([], list_of_maps), do: list_of_maps
  def build_map([head | tail], list_of_maps) do
    maps = process_string(head, list_of_maps)
    build_map(tail, maps)
  end

  def process_string(string, input_list_of_maps, accumulator_list \\ [])
  def process_string("", [], accumulator_list), do: Enum.reverse(accumulator_list)
  def process_string(<<first_letter :: utf8, rest_of_string :: binary>>, [head | tail], accumulator_list) do
    map = add_char_to_freq_map(first_letter, head)
    process_string(rest_of_string, tail, [map | accumulator_list])
  end

  def add_char_to_freq_map(single_char, map) do
    single_char = <<single_char :: utf8>>
    map = if Map.has_key?(map, single_char) do
      Map.put(map, single_char, map[single_char] + 1)
    else
      Map.put(map, single_char, 1)
    end
    map
  end

  def sort_maps([], accumulator), do: Enum.reverse(accumulator)
  def sort_maps([head | tail], accumulator) do
    pair = Map.to_list(head)
    |> Enum.sort(&(elem(&1, 1) > elem(&2, 1)))
    |> List.first
    sort_maps(tail, [pair | accumulator])
  end
end
