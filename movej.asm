########################################################################
# Function Name: movej(idx)
########################################################################
# Functional Description:
#    This routine moves one object to a random spot on the board.
#    The $a0 register is the index of the object to move.
#
########################################################################
# Register Usage in the Function:
#    We save the $ra and $s0 registers on the stack
#    $a0 -- Index of object to move
#    $s0 -- pointer to the object
#    $t0, $t1 -- general calculations.
#    $v0 -- subroutine linkage
#
########################################################################
# Algorithmic Description in Pseudocode:
#    1. Save $ra and $s0 on the stack
#    2. Set $s0 to be the pointer to the object
#    3. Get new random X and Y coordinates for the object
#    4. Compute the object's new board pointer
#    5. Restore $ra and $s0
#
########################################################################

	.data
	.globl movej
	
	.text
movej:
	# initialize address of object array and object index 
	# $t0 = object array address; $t1 = index of object
	la	$t0, objects
	move	$t1, $a0
	# calculate pointer to object's structure to $s0
	sll	$t1, $t1, 4
	add	$s0, $t0, $t1
	# create a stack to save $ra and $s0
	addiu	$sp, $sp, -12
	sw	$ra, 0($sp)
	sw	$s0, 4($sp)
	# compute random X and store into structure
	jal	randX
	lw	$s0, 4($sp)
	sw	$v0, 4($s0)
	# store random X on stack for general calculations
	sw	$v0, 8($sp)
	# compute random Y and store into structure
	jal	randY
	lw	$s0, 4($sp)
	sw	$v0, 8($s0)
	# initialize linelen in $t0 temporarily
	lw	$t0, linelen
	# compute Y * linelen + X and store into $v0
	mult	$v0, $t0
	mflo	$v0
	lw	$t1, 8($sp)
	add	$v0, $v0, $t1
	# initialize board address
	la	$t0, board
	# compute (Y*linelen+X) + board to $t0 for final pointer
	add	$t0, $v0, $t0
	# store final pointer into structure
	sw	$t0, 0($s0)
	# restore $ra, fix stack, and return
	lw	$ra, 0($sp)
	addi	$sp, $sp, 12
	jr	$ra