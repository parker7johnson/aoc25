# Day 1 - Advent of Code 2025

# Read input file
content =
  case File.read("input2") do
    {:ok, file} ->
      String.split(String.trim(file), "\n")

    _ ->
      raise "No file found"
  end

# Shared parser module
defmodule Parser do
  def parse(content) do
    Enum.map(content, fn c ->
      l = Regex.run(~r/([a-zA-Z]+)(\d+)/, c)
      [_ | tl] = l
      tl
    end)
  end
end

# Part 1 Solution
defmodule Part1 do
  def solve(instructions, count \\ 0, start \\ 50)

  def solve([hd | tl], count, start) do
    case hd do
      ["R", num] ->
        num = String.to_integer(num)
        new_position = rem(start + num, 100)

        if new_position == 0 do
          solve(tl, count + 1, 0)
        else
          solve(tl, count, new_position)
        end

      ["L", num] ->
        num = String.to_integer(num)
        new_position = Integer.mod(start - num, 100)

        if new_position == 0 do
          solve(tl, count + 1, 0)
        else
          solve(tl, count, new_position)
        end
    end
  end

  def solve([], count, _), do: count
end

# Part 2 Solution
defmodule Part2 do
  def solve(instructions, count \\ 0, start \\ 50)

  def solve([hd | tl], count, start) do

    case hd do
      ["R", num] ->
        num = String.to_integer(num)
        threshold = 100 - start
        zero_hits = if num >= threshold, do: 1 + div(num - threshold, 100), else: 0
        new_position = rem(start + num, 100)

        solve(tl, count + zero_hits, new_position)

      ["L", num] ->
        num = String.to_integer(num)

        zero_hits =
          cond do
            start == 0 -> div(num, 100)
            num >= start -> 1 + div(num - start, 100)
            true -> 0
          end

        new_position = Integer.mod(start - num, 100)
        solve(tl, count + zero_hits, new_position)
    end
  end

  def solve([], count, _), do: count
end

# Main execution module
defmodule Main do
  def run(content) do
    instructions = Parser.parse(content)

    IO.puts("\n=== Day 1 Solutions ===\n")

    part1_result = Part1.solve(instructions)
    IO.puts("Part 1: #{part1_result}")

    part2_result = Part2.solve(instructions)
    IO.puts("Part 2: #{part2_result}")

    IO.puts("\n======================\n")
  end
end

Main.run(content)
