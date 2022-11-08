open(FH, "@ARGV[0]");
$i = 0;

while ($line = <FH>) {
  $line =~ s/,/ /g;
  $line =~ s/\t/ /g;
  $line =~ s/\:/:/g;
  $line =~ s/^ +//g;
  chomp($line);
  @instruction = split(/ +/, $line);
  if (@instruction[1] eq ":") {
    $labels {@instruction[0]} = $I;
  }
  $i++;
}
close(FH);

open(FH, "@ARGV[0]");
$i = 0;

while ($line = <FH>) {
  $line =~ s/,/ /g;
  $line =~ s/\t+/ /g;
  $line =~ s/\:/ :/g;
  $line =~ s/^ +//g;
  # print($line);
  chomp($line);
  @instruction = split(/ +/, $line);
  # ãƒ©ãƒ™ãƒ«ã®ã‚ã‚‹è¡Œã‚’ãƒ•ã‚£ãƒ¼ãƒ«ãƒ‰ã«åˆ†å‰²ã™ã‚‹  
  if (@instruction[1] eq ":") {
    $op = @instruction[2];
    $f2 = @instruction[3];
    $f3 = @instruction[4];
    $f4 = @instruction[5];
    $f5 = @instruction[6];
  }
  # ãƒ©ãƒ™ãƒ«ã®ãªã„è¡Œã‚’ãƒ•ã‚£ãƒ¼ãƒ«ãƒ‰ã«åˆ†å‰²ã™ã‚‹  
  else {
    $op = @instruction[0];
    $f2 = @instruction[1];
    $f3 = @instruction[2];
    $f4 = @instruction[3];
    $f5 = @instruction[4];
  }

  # æ©Ÿæ¢°èªžã®å‡ºåŠ›
  if ($op   eq "add" ) { p_b(6, 0); p_r3($f2, $f3, $f4);  p_b(11, 0  ); print("\n"); }
  elsif($op eq "addi") { p_b(6, 1); p_r2i($f2, $f3);  p_b(16, $f4); print("\n"); }
  elsif($op eq "sub" ) { p_b(6, 0); p_r3($f2, $f3, $f4);  p_b(11, 2  ); print("\n"); }
  elsif($op eq "lui" ) { p_b(6, 3); p_r2i($f2, "r0");  p_b(16, $f3); print("\n"); }
  elsif($op eq "and" ) { p_b(6, 0); p_r3($f2, $f3, $f4);  p_b(11, 8  ); print("\n"); }
  elsif($op eq "andi") { p_b(6, 4); p_r2i($f2, $f3);  p_b(16, $f4); print("\n"); }
  elsif($op eq "or"  ) { p_b(6, 0); p_r3($f2, $f3, $f4);  p_b(11, 9  ); print("\n"); }
  elsif($op eq "ori" ) { p_b(6, 5); p_r2i($f2, $f3);  p_b(16, $f4); print("\n"); }
  elsif($op eq "xor" ) { p_b(6, 0); p_r3($f2, $f3, $f4);  p_b(11, 10 ); print("\n"); }
  elsif($op eq "xori") { p_b(6, 6); p_r2i($f2, $f3);  p_b(16, $f4); print("\n"); }
  elsif($op eq "nor" ) { p_b(6, 0); p_r3($f2, $f3, $f4);  p_b(11, 11 ); print("\n"); }

  elsif($op eq "sll") { p_b(6, 0); p_r3($f2, $f3, "r0");  p_b(5, $f4); p_b(6, 16); print("\n"); }
  elsif($op eq "srl") { p_b(6, 0); p_r3($f2, $f3, "r0");  p_b(5, $f4); p_b(6, 17); print("\n"); }
  elsif($op eq "sra") { p_b(6, 0); p_r3($f2, $f3, "r0");  p_b(5, $f4); p_b(6, 18); print("\n"); }

  elsif($op eq "lw") { p_b(6, 16); p_r2i($f2, base($f3));  p_b(16, dpl($f3)); print("\n"); }
  elsif($op eq "lh") { p_b(6, 18); p_r2i($f2, base($f3));  p_b(16, dpl($f3)); print("\n"); }
  elsif($op eq "lb") { p_b(6, 20); p_r2i($f2, base($f3));  p_b(16, dpl($f3)); print("\n"); }
  
  elsif($op eq "sw") { p_b(6, 24); p_r2i($f2, base($f3));  p_b(16, dpl($f3)); print("\n"); }
  elsif($op eq "sh") { p_b(6, 26); p_r2i($f2, base($f3));  p_b(16, dpl($f3)); print("\n"); }
  elsif($op eq "sb") { p_b(6, 28); p_r2i($f2, base($f3));  p_b(16, dpl($f3)); print("\n"); }

  elsif($op eq "beq") { p_b(6, 32); p_r2b($f2, $f3); p_b(16, $labels{$f4} - $i - 1); print("\n"); }
  elsif($op eq "bne") { p_b(6, 33); p_r2b($f2, $f3); p_b(16, $labels{$f4} - $i - 1); print("\n"); }
  elsif($op eq "blt") { p_b(6, 34); p_r2b($f2, $f3); p_b(16, $labels{$f4} - $i - 1); print("\n"); }
  elsif($op eq "ble") { p_b(6, 35); p_r2b($f2, $f3); p_b(16, $labels{$f4} - $i - 1); print("\n"); }
  
  elsif($op eq "j"  ) { p_b(6, 40); p_b(26, $labels{$f2}); print("\n"); }
  elsif($op eq "jal") { p_b(6, 41); p_b(26, $labels{$f2}); print("\n"); }
  elsif($op eq "jr" ) { p_b(6, 42); p_r3("r0", $f2, "r0"); p_b(11, 0); print("\n"); }
  
  else  {  print("ERROR: Illegal Instruction\n");  }
  $i++;
}
close(FH);

# $numã‚’2é€²æ•°$digitsã«å¤‰æ›ã—ã¦å‡ºåŠ›
sub p_b {
  ($digits, $num) = @_;
  if ($num >= 0) {
    printf("%0".$digits."b_", $num);
  }
  else {
    print(substr(sprintf("%b ", $num), 32 - $digits));
  }
}

# Råž‹ã®ãƒ¬ã‚¸ã‚¹ã‚¿ç•ªåœ°ã‚’å‡ºåŠ›  
sub p_r3 {
  ($rd, $rs, $rt) = @_;
  $rs =~ s/r//;  p_b(5, $rs);
  $rt =~ s/r//;  p_b(5, $rt);
  $rd =~ s/r//;  p_b(5, $rd);
}

# Iåž‹ã®ãƒ¬ã‚¸ã‚¹ã‚¿ç•ªåœ°ã‚’å‡ºåŠ›  
sub p_r2i {
  ($rt, $rs) = @_;
  $rs =~ s/r//;  p_b(5, $rs);
  $rt =~ s/r//;  p_b(5, $rt);
}

# æ¡ä»¶åˆ†å²ã§æ¯”è¼ƒã™ã‚‹ãƒ¬ã‚¸ã‚¹ã‚¿ç•ªåœ°ã‚’å‡ºåŠ›
sub p_r2b {
  ($rs, $rt) = @_;
  $rs =~ s/r//;  p_b(5, $rs);
  $rt =~ s/r//;  p_b(5, $rt);
}

# ãƒ™ãƒ¼ã‚¹ã‚¢ãƒ‰ãƒ¬ã‚¹ãƒ¬ã‚¸ã‚¹ã‚¿ã®ç•ªåœ°ã‚’è¿”ã™
sub base {
  ($addr) = @_;
  $addr =~ s/.*\(//;
  $addr =~ s/\)//;
  return ($addr);
}

# å¤‰ä½ã‚’è¿”ã™
sub dpl {
  ($addr) = @_;
  $addr = ~s/\(.*\)//;
  return ($addr);
}