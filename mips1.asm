.text
Main :
  addi $sp, $sp, -4
  sw   $ra, 0($sp)
  addi $a0, $0, 5
  jal  Funct
  lw   $ra, 0($sp)
  addi $sp, $sp, 4
  
  move $a0, $v0
  li   $v0, 1
  syscall
  li   $v0, 10
  syscall
Funct:
  addi $sp, $sp, -12
  sw   $s0, 0($sp)
  sw   $s1, 4($sp)
  sw   $ra, 8($sp)
  slti $t0, $a0, 2
  beq  $t0, $0, ELSE
  addi $v0, $s0, 1
  j    EXIT
ELSE:
  addi $s0, $a0, 0
  addi $a0, $a0, -1
  jal  Funct
  addi $s1, $v0, 0
  addi $a0, $s0, -2
  jal  Funct
  add  $v0, $s1, $v0
EXIT:
  lw   $s0, 0($sp)
  lw   $s1, 4($sp)
  lw   $ra, 8($sp)
  addi $sp, $sp, 12
  jr   $ra