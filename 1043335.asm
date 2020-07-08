.data
  string1: .asciiz "Please input the table size (1 to 12):\n\0"
  number: .word 0
  err: .asciiz "Illegal number."
 multi: .asciiz " * "
 equal: .asciiz " = "
  spa: .asciiz "  "
  spa2: .asciiz "\n\0"
.text
main:
input:
  la $t0,number

  li $v0 4
  la $a0,string1
  syscall
  
  li $v0 5
  syscall
  
  # check input <= 12
  slti $t0, $v0, 13
  beq  $t0, $zero, input
  # check input >=  1
  slti $t0, $v0, 1
  bne  $t0, $zero, input
  
  # input number is in $t0
  add $t0, $v0, $zero
    
loop:
  li $v0 4
  la $a0,spa2
  syscall
  addi  $t7, $t0, 1       # inpu number plus 1
  addi	$t1, $t1, 1       # i += 1
  sub   $t2, $t2, $t2
    
  slt   $t6, $t1, $t7    # if t1 < t7
  bne   $t6, $zero,loop2 # ¤p©ó go loop2  
  li    $v0, 10        	 # system service 10 is exit
  syscall                 
  
loop2:
  slt   $t6, $t2, $t0   # if t2 < t0
  beq   $t6, $zero,loop 
  addi  $t2, $t2, 1     # j  +=  1
  mul   $t3, $t2, $t1
  jal   print
  
print:
 # lw $t5,0($t3)      #print the answer 
  li $v0,1
  move $a0, $t1
  syscall
  
  li $v0 4
  la $a0,multi
  syscall
  
  li $v0,1
  move $a0, $t2
  syscall
  
  li $v0 4
  la $a0,equal
  syscall
  
  li $v0,1
  move $a0,$t3
  syscall
  
  li $v0 4
  la $a0,spa
  syscall
  jal loop2
