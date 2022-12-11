defmodule Main do
  def loop_parse(monkeys) do
    case IO.gets("") do
      :eof ->
        MonkeySimulator.run(monkeys, 10000, 0, fn worry ->
          rem(worry, Enum.reduce(monkeys, 1, fn el, acc -> el.divisibility * acc end))
        end)

      _ ->
        loop_parse(monkeys ++ [MonkeyParser.parse()])
    end
  end
end

IO.puts(Main.loop_parse([MonkeyParser.parse()]))
