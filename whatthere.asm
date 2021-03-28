########################################################################
# Function Name: char whatthere(idx)
########################################################################
# Functional Description:
#    The $a0 register is the index of an object.  Find the location of
#    that object on the board, then return the character at that location
#    on the map.
#
########################################################################
# Register Usage in the Function:
#    $a0 -- Index of object in question
#    $t0, $t1 -- general calculations.
#    $v0 -- return value
#
########################################################################
# Algorithmic Description in Pseudocode:
#    1. Compute the effective address of the object
#    2. Fetch the value at that point of the board.
#
########################################################################

	.data
	.globl whatthere
	
	.text
whatthere:
	# initialize address of object array and object index 
	# $t0 = object array address; $t1 = index of object
	la	$t0, objects
	move	$t1, $a0
	# calculate pointer to object's structure to $t0
	sll	$t1, $t1, 4
	add	$t0, $t0, $t1
	# load object's location on board into $t1
	lw	$t1, 0($t0)
	# load character at object's location on board
	lb	$v0, 0($t1)
	# return
	jr	$ra
