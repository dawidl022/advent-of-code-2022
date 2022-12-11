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
