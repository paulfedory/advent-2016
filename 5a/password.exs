defmodule Password do
  def process do
    "ugkcyxxp"
    |> process_hash
    |> IO.inspect
  end

  def process_hash(door_id, index \\ 0, password \\ "")
  def process_hash(door_id, index, password) when byte_size(password) == 8, do: password
  def process_hash(door_id, index, password) do
    the_try = door_id <> Integer.to_string(index)
    hash = :crypto.hash(:md5, the_try) |> Base.encode16
    password =
      cond do
        String.starts_with?(hash, "00000") -> password <> String.at(hash, 5)
        true -> password
      end
    if rem(index, 1_000_000) == 0 do
      IO.inspect "index: #{index}, password: #{password}"
      IO.inspect "hash: #{hash}"
    end
    process_hash(door_id, index + 1, password)
  end
end
