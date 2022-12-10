class Handheld
  attr_reader :total

  def initialize
    @x_reg = 1
    @cc = 0
    @total = 0
  end

  def update_total
    if (@cc - 20) % 40 == 39
      @total += @x_reg * (@cc + 1)
    end
  end

  def process(instruction)
    update_total
    @cc += 1

    if instruction[0] == "addx"
      update_total
      @cc += 1
      @x_reg += Integer(instruction[1])
    end
  end
end

handheld = Handheld.new

loop do
  line = gets
  if line == nil
      break
  end
  line = line.chomp.split

  handheld.process(line)
end

puts handheld.total
