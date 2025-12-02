content =
  case File.read("input2") do
    {:ok, content} -> String.split(String.trim(content), ",")
    _ -> raise "No File Found"
  end

defmodule Parser do
  def parse(content) do
    Enum.map(content, fn s ->
      [hd | tl] = String.split(s, "-", parts: 2)
      {String.trim(hd), String.trim(Enum.at(tl, 0))}
    end)
  end
end

defmodule Part1 do
  def solve(instructions) do
    Enum.map(instructions, fn {f, s} -> calculate_invalid(f, s) end)
    |> Enum.sum()
  end

  def calculate_invalid(open, close) do
    all_invalid_ids(String.to_integer(open), String.to_integer(close), [])
  end

  def all_invalid_ids(open, close, l) when open <= close do
    o_val = Integer.to_string(open)
    c_val = Integer.to_string(close)

    {h, t} = String.split_at(o_val, div(String.length(o_val), 2))

    check =
      if h != "" do
        String.to_integer(h <> h)
      else
        0
      end


    cond do
      open <= check && check <= close && String.length(h) == String.length(t) ->
        new_open = open + min(Integer.pow(10, trunc(:math.floor(max(1, :math.log10(open)) - 1))), 1)

        if open == check do
          all_invalid_ids(new_open, close, [check | l])
        else
          all_invalid_ids(new_open, close, l)
        end

      true ->
        new_open = open + min(Integer.pow(10, trunc(:math.floor(:math.log10(max(10, open))) - 1)), 1)

        new_open =
          if new_open == 1 do
            new_open = 10 
          else
            new_open
          end

        all_invalid_ids(new_open, close, l)
    end
  end

  def all_invalid_ids(_, _, l) do
    Enum.sum(l)
  end
end

defmodule Part2 do
  def solve(instructions) do
  end
end

defmodule Main do
  def run(content) do
    instructions = Parser.parse(content)

    IO.puts("\n=== Day 1 Solutions ===\n")

    part1_result = Part1.solve(instructions)
    IO.puts("Part 1: #{part1_result}")

    # part2_result = Part2.solve(instructions)
    # IO.puts("Part 2: #{part2_result}")

    IO.puts("\n======================\n")
  end
end

Main.run(content)
