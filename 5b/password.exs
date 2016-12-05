defmodule Password do
  def process do
    "ugkcyxxp"
    |> process_hash
    |> IO.inspect
  end

  def process_hash(door_id, index \\ 0, password \\ %{})
  def process_hash(door_id, index, password) when map_size(password) == 8, do: password
  def process_hash(door_id, index, password) do
    the_try = door_id <> Integer.to_string(index)
    hash = :crypto.hash(:md5, the_try) |> Base.encode16

    password = modify_password_map(hash, password)

    if rem(index, 1_000_000) == 0 do
      IO.inspect "index: #{index}, password: #{Map.keys(password)}"
      IO.inspect "hash: #{hash}"
    end
    process_hash(door_id, index + 1, password)
  end

  def modify_password_map(hash, password) do
    if String.starts_with?(hash, "00000") do
      position = String.at(hash, 5)
      letter = String.at(hash, 6)
      password =
        cond do
          position >= "0" && position <= "7" && !Map.has_key?(password, position) ->
            Map.put(password, position, letter)
          true -> password
        end
    else
      password
    end
  end
end
