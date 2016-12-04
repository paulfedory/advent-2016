defmodule Room do

  def process do
    File.open("input2.txt")
    |> read_from_file
    |> split_lines
    |> split_alpha([])
    |> split_sector([])
    |> Enum.filter(fn(x) -> elem(x, 0) == elem(x, 3) end)
    |> decrypt_words([])
    |> Enum.sort(fn(x, y) -> elem(x, 1) < elem(y, 1) end)
    |> Enum.map(&IO.inspect/1)
    ""
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

    just_letters = List.delete(array, List.last(array))
    head = Tuple.append(head, Enum.join(just_letters, "-"))

    letters = just_letters
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

    head = Tuple.append(head, letters)
    head = Tuple.delete_at(head, 0)

    split_sector(tail, [head | accumulator])
  end

  def decrypt_words([], accumulator), do: Enum.reverse(accumulator)
  def decrypt_words([head | tail], accumulator) do
    decrypt_words(tail, [decrypt_tuple(elem(head, 1), elem(head, 2)) | accumulator])
  end

  def decrypt_tuple(sector, words, acc \\ "")
  def decrypt_tuple(sector, "", acc) do
    {sector, String.reverse(acc)}
  end
  def decrypt_tuple(sector, words=<<first_letter::utf8, rest_of_string::binary>>, acc) do
    adjustment = rem(sector, 26)
    decrypted_letter = cond do
      first_letter == 45 -> 32 # convert dashes to spaces
      first_letter + adjustment > 122 -> first_letter + adjustment - 26 # loop around alphabet if necessary
      true -> first_letter + adjustment #normal adjustment is less than 'z'
    end

    decrypt_tuple(sector, rest_of_string, <<decrypted_letter::utf8>> <> acc)
  end
end
