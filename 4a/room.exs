defmodule Room do

  def process do
    File.open("input2.txt")
    |> read_from_file
    |> split_lines
    |> split_alpha([])
    |> split_sector([])
    |> Enum.filter(fn(x) -> elem(x, 0) == elem(x, 2) end)
    |> Enum.reduce(0, fn(x, acc) ->
      acc + elem(x, 1)
    end)
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

  def split_alpha([], accumulator), do: Enum.reverse(accumulator)
  def split_alpha([head | tail], accumulator) do
    formatted =
      head
      |> String.split(["[", "]"])
      |> List.delete("")
      |> List.to_tuple
    split_alpha(tail, [ formatted | accumulator ])
  end

  def split_sector([], accumulator), do: Enum.reverse(accumulator)
  def split_sector([head | tail], accumulator) do
    array = head
    |> elem(0)
    |> String.split("-")

    # add sector number to list
    last = String.to_integer(List.last(array))
    head = Tuple.append(head, last)

    letters = List.delete(array, List.last(array))
    |> Enum.join
    |> String.split("")
    |> List.delete("")
    |> Enum.reduce(%{}, fn(letter, acc) -> Map.update(acc, letter, 1, &(&1 + 1)) end)
    |> Enum.to_list
    |> Enum.sort(fn(x, y) ->
      cond do
        elem(x, 1) > elem(y, 1) -> true
        elem(x, 1) == elem(y, 1) -> elem(x, 0) < elem(y, 0)
        true -> false
      end
    end)
    |> Enum.take(5)
    |> Enum.map_join(&(elem(&1, 0)))

    #IO.inspect head
    head = Tuple.append(head, letters)
    head = Tuple.delete_at(head, 0)

    split_sector(tail, [head | accumulator])
  end
end
