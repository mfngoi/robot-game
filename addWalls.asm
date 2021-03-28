########################################################################
# Function Name: addWalls
########################################################################
# Functional Description:
#    This routine adds extra walls in the middle of the board.  The global
#    numWalls indicates how many to add.  Since we randomly place these,
#    it is possible we will place some at the same spot, so there might
#    be somewhat fewer than numWalls.
#
########################################################################
# Register Usage in the Function:
#    -- Since this calls subroutines, we save $ra on the stack, then
#    -- restore it.  We also save $s0 and $s1 on the stack.
#    $a0, $v0 -- Subroutine parameter and return passing.
#    $s0 -- Loop counter: how many walls still to place
#    $s1 -- The x-coordinate of the wall
#    $t0 -- Pointer where to store the wall in the board
#    $t1 -- general calculations.
#
########################################################################
# Algorithmic Description in Pseudocode:
#    1. Save the return address and S registers on the stack
#    2. Loop based on the number of walls to place:
#   	 2a. Get a random X coordinate (into $s1) and random Y coordinate.
#   	 2b. Compute Y * linelen + X
#   	 2c. Compute the final pointer by adding the 2b value to the address
#   		 of the board.
#   	 2d. Store a wall character at that pointer.
#    5. Restore the return address and S registers
#
########################################################################

	.data
	.globl addWalls
	
	.text
addWalls:
	# initialize constant numwalls
	lw	$s0, numwalls
	# create stack and save $ra on stack
	addiu	$sp, $sp, -12
	sw	$ra, 0($sp)
wallLoop:	
	# save numwalls to stack as loop counter
	sw	$s0, 4($sp)
	# test to break loop if numWalls == 0
	beqz	$s0, wallEnd
	# call randX for random X coordinate into $s1
	# and store on stack
	jal	randX
	move	$s1, $v0
	sw	$s1, 8($sp)
	# call randY for random Y coordinate into $v0
	jal	randY
	# initialize board address
	la	$t0, board
	# initialize linelen in $t1 temporarily
	lw	$t1, linelen
	# compute Y * linelen + X and store into $v0
	mult	$v0, $t1
	mflo	$v0
	lw	$s1, 8($sp)
	add	$v0, $v0, $s1
	# compute (Y*linelen+X) + board to $t0 for final pointer
	add	$t0, $v0, $t0
	# add wall to board
	li	$t1, 35
	sb	$t1, 0($t0)
	# decrement loop counter and loop 
	lw	$s0, 4($sp)
	addi	$s0, $s0, -1
	j	wallLoop
# restore $ra, fix stack, and return
wallEnd:
	lw	$ra, 0($sp)
	addi	$sp, $sp, 12
	jr	$ra

