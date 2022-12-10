class Handheld
  def initialize
    @x_reg = 1
    @cc = 0
  end

  def display_crt_pixel
    x_pos = @cc % 40
    if @x_reg >= x_pos - 1 && @x_reg <= x_pos + 1
      print '#'
    else
      print '.'
    end
    if x_pos == 39
      puts
    end
  end

  def process(instruction)
    display_crt_pixel
    @cc += 1

    if instruction[0] == "addx"
      display_crt_pixel
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
