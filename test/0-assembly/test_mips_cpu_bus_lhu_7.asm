lui $v1 0xBFC0
addiu $v1 $v1 0x0020
lhu $v0 0x000C($v1)
jr $zero
nop

#BCF0002c=4422c6b2
#assert(v0== 0000c6b2 )
