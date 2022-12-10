total = 0
$x_reg = 1
$cc = 0

def display_crt_pixel
  if $x_reg >= $cc % 40 - 1 && $x_reg <= $cc % 40 + 1
    print '#'
  else
    print '.'
  end
  if ($cc + 1) % 40 == 0
    puts
  end
end

loop do
  line = gets
  if line == nil
      break
  end
  line = line.chomp.split


  if line[0] == "noop"
    if ($cc - 20) % 40 == 39
      total += $x_reg * ($cc + 1)
    end
    display_crt_pixel
    $cc += 1
  else
    if ($cc - 20) % 40 == 39
      total += $x_reg * ($cc + 1)
    end
    display_crt_pixel
    $cc += 1
    if ($cc - 20) % 40 == 39
      total += $x_reg * ($cc + 1)
    end
    display_crt_pixel
    $cc += 1
    $x_reg += Integer(line[1])
  end
end

puts total
puts $x_reg
puts $cc
