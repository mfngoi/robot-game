########################################################################
# Function Name: placeobj(idx, type)
########################################################################
# Functional Description:
#    The $a0 register is the index of an object.  $a1 is the type for
#    this object.  Create a new object, then find a place for it on the
#    board.
#
########################################################################
# Register Usage in the Function:
#    $a0 -- Index of object in question
#    $s0 -- pointer to the object's structure.
#    $t0, $t1 -- general calculations.
#    $v0 -- subroutine linkage
#
########################################################################
# Algorithmic Description in Pseudocode:
#    1. Save space on the stack for the return address and $s0
#    2. Set $s0 to the pointer to this object
#    3. Store the type of the object
#    4. Compute a random X and random Y for the object, storing these.
#    5. Compute the pointer to this location on the board.
#    6. See if the location is empty ('.').  If not, loop back to 4.
#
########################################################################

	.data
	.globl placeobj
	
	.text
placeobj:
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
	# stores type of object into structure
	sw	$a1, 12($s0)
	
placeLoop:
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
	# check if location of board is empty
	lb	$t1, 0($t0)
	li	$t0, 46
	# if not empty then loop to new location
	bne	$t0, $t1, placeLoop
	# restore $ra, fix stack, and return
	lw	$ra, 0($sp)
	addi	$sp, $sp, 12
	jr	$ra
	
