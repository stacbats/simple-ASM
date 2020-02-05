
.label SCREEN_RAM	= $0400
.label COLOR_RAM 	= $d800

.label BACKGRND = $d021
.label BORDER	= $d020

BasicUpstart2(Entry)


TextMap:
	.import binary "../assets/Map.bin"

ColorRamp:
	.byte $01,$0b,$0c,$0f,$00,$01,$03,$0e,$06,$0b,$0c,$0f,$00

ColorIndex:
	.byte $00

Entry:

//  initalization
//  SET CHARSET
	lda #%00011000
	sta $d018

//      Screen colours
        lda #11
        sta BORDER
        sta BACKGRND

        lda #131
        jsr ClearScreen



	// Draw Text
	ldx #0
!:
	lda TextMap, x
	sta SCREEN_RAM + 12 * 40, x		
	inx 
	cpx	#80
	bne !-

	//lda #131
	//jsr ClearScreen

	// Wait for Raster to hit correct point
Loop:
	// Increment Colour Ramp Index
	ldx ColorIndex
	inx
	cpx	#14
	bne !+
	ldx #0
!:
	stx ColorIndex

	// Begin plotting colours in a loop
	ldy #0
InnerLoop:
	lda	ColorRamp, x
	sta COLOR_RAM +12 * 40 + 5, y  // load 80 chars at row 12
	sta COLOR_RAM +13 * 40 + 5, y

	inx // Colour Index
	cpx #14
	bne !+
	ldx #0
!:
	iny // Screen column index
	cpy #24
	bne InnerLoop

	// Wait for Raster
	lda #$a0
!:
	cmp $d012 
	bne !-

	// repeat
	jmp Loop

ClearScreen: {
		ldx #250
!:
		dex 
		sta SCREEN_RAM, x
		sta SCREEN_RAM + 250, x
		sta SCREEN_RAM + 500, x
		sta SCREEN_RAM + 750, x
		bne !-
		rts 

}

* = $2000 "Character Map"
	.import binary "../assets/Char.bin"