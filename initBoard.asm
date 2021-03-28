########################################################################
# Function Name: initBoard
########################################################################
# Functional Description:
#    This routine initializes the board.  This will be a 2D array in
#    row-order.  The edges of the board will all be Wall characters ('#'),
#    and the center will be filled with '.'.  At the end of each row
#    will be a newline, and at the end of the array will be a 0 to terminate
#    the string.
#
########################################################################
# Register Usage in the Function:
#    -- This is a leaf function, so we don't need to save the $ra
#    -- register, and we are free to use any of the $t registers.
#    $t0 -- Pointer into the board
#    $t1 -- Value we are going to place on the board
#    $t5, $t6, $t7, $t8 -- Loop counters for the different loops we are forming.
#    
#    -- Note: we need to place 4 different characters at various places
#    -- of the board: #, ., newline, and 0.  We can store these four
#    -- values into different $t registers at the start of the routine.
########################################################################
# Algorithmic Description in Pseudocode:
#    Note: In the following, we say 'Place <char> on the board'.  This
#    means to do the following:
#        a. Have the value of <char> in register $t1
#        b. store byte the value in $t1 to 0($t0)
#        c. increment the value of of $t0.
#
#    1. Set $t0 to point to the board
#    2. Draw the top row of the board:
#        a. Looping 'wid' times, place '#' on the board.
#        b. Place newline on the board.
#    3. Draw the middle of the board.  Loop hgt - 2 times:
#        a. Place '#' on the board.
#        b. Looping wid - 2 times, place '.' on the board.
#        c. Place '#' on the board.
#        d. Place newline on the board.
#    4. Draw the bottom row of the board:
#        a. Looping wid times, place '#' on the board.
#        b. Place newline on the board.
#    5. End the string by placing 0 on the board.
#
########################################################################

	.data
	.globl initBoard
	
	.text
initBoard:
	# $t0 points to address of board
	la	$t0, board
	# $t1 = "#"
	li	$t1, 35
	# intitialize counters for top loop
	li	$t7, 0	
	lw	$t8, wid
# loops (wid) times and adds row of "#" to board
topLoop:
	# test to break top loop when $t7 >= $t8
	bge	$t7, $t8, topDone
	sb	$t1, 0($t0)		
	addi	$t0, $t0, 1		
	addi	$t7, $t7, 1		
	j	topLoop	
topDone:			
	# initialize counters for middle loop
	li	$t5, 0
	lw	$t6, hgt
	addi	$t6, $t6, -2
# loops (hgt-2) times to fill in middle of the board
middleLoop:
	# test to break middle loop when $t5 >= $t6
	bge	$t5, $t6, middleDone
	# adds "\n" to board to segment new line
	li	$t1, 10			
	sb	$t1, 0($t0)		
	addi	$t0, $t0, 1	
	# adds "#" into board
	li	$t1, 35	
	sb	$t1, 0($t0)
	addi	$t0, $t0, 1
	# initialize counters for inner loop
	li	$t7, 0
	lw	$t8, wid
	addi	$t8, $t8, -2
# loops (wid-2) times and adds row of "." to board
innerLoop:
	# test to break inner loop when $t7 >= $t8
	bge	$t7,$t8, innerDone
	# adds "." into board
	li	$t1, 46
	sb	$t1, 0($t0)
	addi	$t0, $t0, 1
	addi	$t7, $t7, 1
	j	innerLoop
innerDone:
	# adds "#" into board
	li	$t1, 35	
	sb	$t1, 0($t0)
	addi	$t0, $t0, 1
	# increments counter for middle loop
	addi	$t5, $t5, 1
	j	middleLoop
middleDone:
	# adds "\n" to board to segment new line
	li	$t1, 10			
	sb	$t1, 0($t0)		
	addi	$t0, $t0, 1
	# $t1 = "#"
	li	$t1, 35
	# initialize counters for end loop
	li	$t7, 0	
	lw	$t8, wid
# loops (wid) times and adds row of "#" to board
endLoop:	
	# test to break end loop when $t7 >= $t8
	bge	$t7, $t8, finish
	sb	$t1, 0($t0)		
	addi	$t0, $t0, 1		
	addi	$t7, $t7, 1		
	j	endLoop		
finish:	
	# sets 0 to end of board to make a null-terminated string	
	li	$t1, 0
	sb	$t1, 0($t0)
	# return
	jr	$ra

