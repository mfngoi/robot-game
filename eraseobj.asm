########################################################################
# Function Name: eraseobj(idx)
########################################################################
# Functional Description:
#    The $a0 register is the index of an object.  Find the location of
#    that object on the board, then store floor ('.') at that spot.
#
########################################################################
# Register Usage in the Function:
#    $a0 -- Index of object in question
#    $t0, $t1, $t2 -- general calculations.
#
########################################################################
# Algorithmic Description in Pseudocode:
#    1. Compute the effective address of the object
#    2. Store a '.' at that point of the board
#
########################################################################

	.data
	.globl eraseobj
	
	.text
eraseobj:
	# initialize address of object array and object index 
	# $t0 = object array address; $t1 = index of object
	la	$t0, objects
	move	$t1, $a0
	# calculate pointer to object's structure to $t0
	sll	$t1, $t1, 4
	add	$t0, $t0, $t1
	# load object's location on board into $t1
	lw	$t1, 0($t0)
	# store "." at object's location
	li	$t2, 46
	sb	$t2, 0($t1)
	# return
	jr	$ra
	