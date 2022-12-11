defmodule MonkeySimulator do
  def run(monkeys, rounds_left, monkey_turn, calc_new_worry) do
    cond do
      rounds_left == 0 ->
        [first | [second | _]] = Enum.sort_by(monkeys, fn mon -> mon.inspection_count end, :desc)
        first.inspection_count * second.inspection_count

      monkey_turn == length(monkeys) ->
        run(monkeys, rounds_left - 1, 0, calc_new_worry)

      true ->
        run(
          run_monkey(monkeys, monkey_turn, calc_new_worry),
          rounds_left,
          monkey_turn + 1,
          calc_new_worry
        )
    end
  end

  defp run_monkey(monkeys, monkey_turn, calc_new_worry) do
    run_monkey_items(monkeys, monkey_turn, calc_new_worry)
  end

  defp run_monkey_items(monkeys, monkey_turn, calc_new_worry) do
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

      new_worry = calc_new_worry.(monkey.operation.operator.(worry, operand))

      new_monkeys =
        List.update_at(monkeys, monkey_turn, fn _ ->
          %{monkey | items: tl(monkey.items), inspection_count: monkey.inspection_count + 1}
        end)

      target_monkey =
        if rem(new_worry, monkey.divisibility) == 0 do
          Enum.at(monkeys, monkey.true_monkey)
        else
          Enum.at(monkeys, monkey.false_monkey)
        end

      run_monkey_items(
        List.update_at(
          new_monkeys,
          target_monkey.i,
          fn _ -> Map.put(target_monkey, :items, [new_worry | target_monkey.items]) end
        ),
        monkey_turn,
        calc_new_worry
      )
    end
  end
end
