lui v1 0xbfc0
lw t1 0x28(v1)
jr zero
addiu v0 t1 0x0

# assert(register_v0==32'h000000C0)
