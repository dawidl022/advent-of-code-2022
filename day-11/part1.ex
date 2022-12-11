defmodule Main do
  def loop_parse(monkeys) do
    case IO.gets("") do
      :eof -> MonkeySimulator.run(monkeys, 20, 0, fn worry -> div(worry, 3) end)
      _ -> loop_parse(monkeys ++ [MonkeyParser.parse()])
    end
  end
end

IO.puts(Main.loop_parse([MonkeyParser.parse()]))
