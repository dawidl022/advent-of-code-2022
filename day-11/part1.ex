defmodule MonkeyParser do
  def parse do
    %{
      i: parse_index(read()),
      items: parse_start_items(read()),
      operation: parse_operation(read()),
      divisibility: parse_divisibility(read()),
      true_monkey: parse_true_monkey(read()),
      false_monkey: parse_false_monkey(read()),
      inspection_count: 0
    }
  end

  defp read do
    String.trim(IO.gets(""))
  end

  defp parse_int(number) do
    {result, _} = Integer.parse(number)
    result
  end

  defp parse_index("Monkey " <> <<i::bytes-size(1)>> <> ":") do
    parse_int(i)
  end

  defp parse_start_items("Starting items: " <> raw_items) do
    Enum.map(String.split(raw_items, ", "), fn item -> parse_int(item) end)
  end

  defp parse_operation(
         "Operation: new = old " <> <<raw_operator::bytes-size(1)>> <> " " <> raw_operand
       ) do
    %{
      operand:
        case raw_operand do
          "old" -> :old
          _ -> parse_int(raw_operand)
        end,
      operator:
        case raw_operator do
          "+" -> fn a, b -> a + b end
          "*" -> fn a, b -> a * b end
        end
    }
  end

  defp parse_divisibility("Test: divisible by " <> number) do
    parse_int(number)
  end

  defp parse_true_monkey("If true: throw to monkey " <> number) do
    parse_int(number)
  end

  defp parse_false_monkey("If false: throw to monkey " <> number) do
    parse_int(number)
  end
end

defmodule MonkeySimulator do
  def run(monkeys, round, monkey_turn) do
    cond do
      round == 20 ->
        [first | [second | _]] = Enum.sort_by(monkeys, fn mon -> mon.inspection_count end, :desc)
        first.inspection_count * second.inspection_count

      # get highest inspection count
      monkey_turn == length(monkeys) ->
        run(monkeys, round + 1, 0)

      true ->
        run(run_monkey(monkeys, monkey_turn), round, monkey_turn + 1)
    end
  end

  defp run_monkey(monkeys, monkey_turn) do
    run_monkey_items(monkeys, monkey_turn)
  end

  defp run_monkey_items(monkeys, monkey_turn) do
    monkey = hd(Enum.filter(monkeys, fn mon -> mon.i == monkey_turn end))

    if length(monkey.items) == 0 do
      monkeys
    else
      worry = Enum.at(monkey.items, 0)

      operand =
        case monkey.operation.operand do
          :old -> worry
          _ -> monkey.operation.operand
        end

      new_worry = div(monkey.operation.operator.(worry, operand), 3)

      new_monkeys =
        List.update_at(monkeys, monkey_turn, fn _ ->
          %{monkey | items: tl(monkey.items), inspection_count: monkey.inspection_count + 1}
        end)

      if rem(new_worry, monkey.divisibility) == 0 do
        # TODO refactor duplication
        true_monkey = Enum.at(monkeys, monkey.true_monkey)

        run_monkey_items(
          List.update_at(
            new_monkeys,
            monkey.true_monkey,
            fn _ -> Map.put(true_monkey, :items, [new_worry | true_monkey.items]) end
          ),
          monkey_turn
        )
      else
        false_monkey = Enum.at(monkeys, monkey.false_monkey)

        run_monkey_items(
          List.update_at(
            new_monkeys,
            monkey.false_monkey,
            fn _ -> Map.put(false_monkey, :items, [new_worry | false_monkey.items]) end
          ),
          monkey_turn
        )
      end
    end
  end
end

defmodule Main do
  def loop_parse(monkeys) do
    case IO.gets("") do
      :eof -> MonkeySimulator.run(monkeys, 0, 0)
      _ -> loop_parse(monkeys ++ [MonkeyParser.parse()])
    end
  end
end

IO.puts(Main.loop_parse([MonkeyParser.parse()]))
