:BasicUpstart2(entry)

	.const VIC2 = $d000		// sprite pointer
	.namespace sprite {
	.label position = VIC2
	.label enable_bit = VIC2 + 21
	}

entry:		

	lda #%00000001		//  enable for sprite 1
	sta sprite.enable_bit

	.var x = 150		// place sprite x co-ord
	.var y = 110		// place sprite y co-ord

	lda #x
	sta sprite.position + 0
	lda #y
	sta sprite.position + 1
	
	rts



