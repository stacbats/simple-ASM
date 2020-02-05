//====================================================================
BasicUpstart2(main)

.label BORDER     = $d020   // border colour
.label BACKGRND   = $d021   // background colour
.label CLEAR      = $e544   // clear screen
.label SCNKEY     = $ff9f   // scan keyboard
.label GETIN      = $ffe4   // read keyboard

delay:  .byte 15    // this value sets the speed of the colour effect
//====================================================================
main:   
        jsr CLEAR       // clear screen
        lda #0          // black value
        sta BORDER      // set border to 0 (black)
        sta BACKGRND    // set background to 0 (black)
loop:  
        jsr display_screen   // display the screen
        jsr check_keys       // scan the keyboard
        jmp loop             // restart loop

//===========================================================

check_keys:
        jsr SCNKEY    // scan keyboard
        jsr GETIN     // read keyboard buffer  
One:
        cmp #$31      // has key '1' been pressed?
        bne Two       // if no, branch forwards
        inc BORDER    // if yes, change the border colour
Two:
        cmp #$32         // has key '2' been pressed?
        bne check_keys_end   // if no, branch forwards
        inc BACKGRND      // if yes, change the background colour
check_keys_end:
      rts
//============================================================
display_screen:
      ldx #0              // set x to zero - begining of string 
draw_loop: 
      lda string,x        // load string characters
      cmp #0              // have we reached the end?
      beq draw_exit       // yes? exit
      sta $0400+8*40,x    // if no ..store the character at screen ram + 9 rows down + x
colours:
      dec delay           // decrement the delay value
      bne !+              // if it is not zero, branch forwards
      lda #175             // otherwise if it is zero, reset ( lower the number quicker colour,255 slower.
      sta delay
      inc $d800+8*40,x    // change the colour of one of our characters
!:
      inx
      jmp draw_loop

draw_exit:
      rts
//====================================================================
string: .text " press 1/2 to change border/background"
		    .text "               get pressing"
        .text "                               enjoy"
        .byte 0
//====================================================================

