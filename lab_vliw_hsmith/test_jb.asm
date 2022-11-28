.text
li x4, -1
li x5, 2
beq x4, x5, target3
bne x4, x5, target3
target1: blt x4, x5, target4
jal target5
j exit
target2: nop
target3: jal x1, target1
target4: jalr x1
target5: bge x4, x5, target1
bgeu x4, x5, target6
beq x0, x0, target1
target6: bltu x4, x4, target1
exit: