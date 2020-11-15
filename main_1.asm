BasicUpstart2(entry)

    .label PRINT_LINE       = $AB1E
    .label krljmp_CHROUT    = $FFD2
    .label Name             = $d800
entry:

    lda #BLACK
    sta $d020
    sta $d021

    lda #147
    jsr krljmp_CHROUT

    lda #<THESAINT    // Grab Lo Byte of Hello World Location
    ldy #>THESAINT    // Grab Hi Byte of Hello World Location
    jsr PRINT_LINE      // Print The Line


    ldx #WHITE
colour:
    inx
    stx Name
    stx Name + 1 + 2
    stx Name + 2
    stx Name + 4
    stx Name + 6
    inx
    
    jmp colour 

THESAINT:
    .text "STACY BATES"    // the string to print
    .byte 00               // The terminator character
    rts