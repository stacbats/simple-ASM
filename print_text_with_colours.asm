
//====================================================================

BasicUpstart2(main)

.label BORDER     = $d020   // c64 border colour
.label BACKGRND   = $d021   // c64 background colour
.label CLEAR      = $e544   // clear screen - 58692 kernel routine
.label SCNKEY     = $ff9f   // scan keyboard - 65439 kernal routine
.label GETIN      = $ffe4   // read keyboard buffer - 65508kernel routine

delay:  .byte 60    // this value sets the speed of the colour effect

//====================================================================

main:   
        jsr CLEAR    // clear screen - kernel routine
        lda #0
        sta BORDER     // set border to 0 (black)
        sta BACKGRND   // set background to 0 (black)
loop:  
        jsr display_screen   // display the screen
        jsr check_keys        // scan the keyboard
        jmp loop             // restart loop

//===========================================================

check_keys:
        jsr SCNKEY // scan keyboard - kernal routine
        jsr GETIN // read keyboard buffer - kernel routine
          
One:
        cmp #$31   // has key '1' been pressed?
        bne Two     // if no, branch forwards
        inc BORDER   // if yes, change the border colour

Two:
        cmp #$32         // has key '2' been pressed?
        bne check_keys_end   // if no, branch forwards
        inc BACKGRND      // if yes, change the background colour
   
check_keys_end:
      rts
//============================================================

display_screen:
      ldx #0   // set x to zero so we start at the beginning of the string

draw_loop: 
      lda string,x   //  load a character from the string
      cmp #0     // have we reached the end?
      beq draw_exit    // if yes, exit
      sta $0400+8*40,x   // otherwise store the character at screen ram + 9 rows down + x

colours:
      dec delay     //   decrement the delay value
      bne !+       //   if it is not zero, branch forwards
      lda #255    // otherwise if it is zero, reset the delay to 255...
      sta delay
      inc $d800+8*40,x   // ...and change the colour of one of our characters
  !:                       // (we change the colour at colour ram + 9 rows down + x)
      inx
      jmp draw_loop

draw_exit:
      rts
//====================================================================
string:   .text " press 1/2 to change border/background"
          .byte 0
//====================================================================
