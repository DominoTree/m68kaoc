use madmac syntax, not mot

clr is used instead of move 0 because it saves bytes

addq is used to reset the stack pointer because it is quick but can only addq can only add up to 8 (3 bits)

data segment contains values

bss segment contains references to zero-initialize but no values (minimizing binary size)

jsr and rts reset the stack pointer automatically
