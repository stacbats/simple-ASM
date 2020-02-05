// converted from BASIC from the Commodore 64 Programmer's reference guide page 167
.pc = $0801 "Basic Upstart Program"
:BasicUpstart($0810)

.pc = $0810 "Main Program"

// animating dancing mouse
// it is a bit buggy in the sid kernel routine
.const delay = $60

.macro small_delay() {
	ldx #0
!t:
	inx
	cpx #delay
	bne !t-
}

	lda #$08
	ldx #$08
	sta $d020
	stx $d021

	// *********************   setup sid
	lda #15
	sta $d418
	lda #220
	sta $d400
	lda #68
	sta $d401
	lda #15
	sta $d405
	lda #215
	sta $d406
	lda #120
	sta $d407
	lda #100
	sta $d408
	lda #15
	sta $d40c
	lda #215
	sta $d40d
	// *******************    clear screen
	ldx #0
!l:
	lda #' '
	sta $0400, x
	sta $0500, x
	sta $0600, x
	sta $06e8, x 
	lda #2
	sta $d800, x
	inx
	bne !l-
	// clear sprite msb register
	lda #0
	sta $d010
	// enable sprite 0
	lda #1
	sta $d015
	// store pictures at $3000
	ldx #0

	// setup sprite 0
	lda #$00
	sta $d027
	lda #68
	sta $d001
	// ************************   SPRITE   ***********
	lda #$ff
	sta $d01c
	lda #5
	sta $d025
	lda #11
	sta $d026



	// print text
	ldx #0
!l:
	lda text, x
	sta $04c8, x
	inx
	cpx #23
	bne !l-
	// vic kernel
kernel:
	// move 3 pixels at a time
	lda $d000
	clc
	adc #2
	sta $d000
	bcc sid
	lda $d010
	cmp #1
	bne !l+
	brk
!l:
	lda #1
	sta $d010
sid:
	// sid kernel
	lda sprptr
	cmp #192
	bne !l+
	lda #129
	sta $d404

	:small_delay()

	lda #128
	sta $d404
!l:
	lda sprptr
	cmp #193
	bne !l+
	lda #129
	sta $d40b

	:small_delay()

	lda #128
	sta $d40b
!l:
	// advance sprite
	inc sprptr
	lda sprptr
	cmp #197		// #195
	bne !l+
	lda #192		// #195
	sta sprptr
!l:
	// update sprite
	lda sprptr
	sta $07f8		// our franks pointer
//	inc $07f8, x	// new code

	// vsync handling
.for (var i = 0; i < 2 * 3; i++) {
!wait:
	bit $d011
	bpl !wait-
!wait:
	bit $d011
	bmi !wait-
}
	jmp kernel
sprptr:
	.byte 192
text:
	.text " where is my charger !!!"
* = $3000
frank:
//spr_img0
.byte $02,$aa,$00,$02,$a5,$00,$02,$5a,$00,$02,$55,$00,$02,$54,$00,$02
.byte $65,$00,$00,$54,$00,$02,$bc,$00,$02,$ff,$95,$02,$ff,$e4,$02,$aa
.byte $a0,$03,$fc,$00,$03,$fc,$00,$02,$fc,$00,$00,$fc,$00,$00,$f8,$00
.byte $00,$f8,$00,$00,$fb,$00,$03,$e3,$00,$03,$e3,$c0,$02,$82,$80,$80
//spr_img1
.byte $02,$aa,$00,$02,$a5,$00,$02,$5a,$00,$02,$55,$00,$02,$54,$00,$02
.byte $65,$00,$00,$54,$00,$00,$bc,$00,$02,$ff,$90,$02,$ff,$f5,$02,$aa
.byte $d4,$03,$fc,$a0,$03,$fc,$00,$02,$fc,$00,$00,$fc,$00,$00,$f8,$00
.byte $00,$fb,$00,$03,$eb,$c0,$03,$80,$c0,$03,$00,$80,$02,$80,$a0,$80
//spr_img2
.byte $00,$aa,$80,$00,$a5,$40,$00,$96,$80,$00,$95,$40,$00,$95,$00,$00
.byte $99,$40,$00,$54,$00,$00,$bc,$00,$02,$ff,$90,$02,$ff,$f5,$02,$aa
.byte $f4,$03,$fc,$a0,$02,$fc,$00,$02,$fc,$00,$00,$bc,$00,$00,$b8,$00
.byte $00,$f8,$00,$03,$fb,$00,$03,$ab,$00,$0a,$03,$00,$08,$02,$80,$80
//spr_img3
.byte $02,$aa,$00,$02,$a5,$00,$02,$5a,$00,$02,$55,$00,$02,$54,$00,$02
.byte $65,$00,$00,$54,$00,$02,$be,$00,$02,$ff,$90,$02,$ff,$f5,$02,$ab
.byte $90,$03,$fa,$80,$02,$fc,$00,$02,$fc,$00,$00,$bc,$00,$00,$b8,$00
.byte $00,$fe,$00,$00,$fe,$00,$00,$fa,$00,$00,$e8,$00,$00,$e0,$00,$80
//spr_img4
.byte $02,$aa,$00,$02,$a5,$00,$02,$5a,$00,$02,$55,$00,$02,$54,$00,$02
.byte $65,$00,$00,$54,$00,$02,$bc,$00,$02,$ff,$95,$02,$ff,$f4,$02,$ae
.byte $a0,$03,$fb,$00,$02,$fc,$00,$02,$fc,$00,$00,$bc,$00,$00,$b8,$00
.byte $00,$3e,$00,$00,$fe,$00,$00,$fe,$00,$00,$c0,$80,$00,$a0,$a0,$80
