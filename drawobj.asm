########################################################################
# Function Name: drawobj(idx)
########################################################################
# Functional Description:
#    The $a0 register is the index of an object.  Draw the object's character
#    at that point on the board.
#
########################################################################
# Register Usage in the Function:
#    $a0 -- Index of object in question
#    $t0, $t1, $t2, $t3 -- general calculations.
#
########################################################################
# Algorithmic Description in Pseudocode:
#    1. Compute the effective address of the object
#    2. Determine the character for this type of object
#    3. Place that character in the board at the object's location.
#
########################################################################

	.data
	.globl drawobj
	
	.text
drawobj:
	# initialize address of object array and object index 
	# $t0 = object array address; $t1 = index of object
	la	$t0, objects
	move	$t1, $a0
	# calculate pointer to object's structure to $t0
	sll	$t1, $t1, 4
	add	$t0, $t0, $t1
	# load object's type into $t1
	lw	$t1, 12($t0)
	# load object's location on board into $t2
	lw	$t2, 0($t0)
	# check for type 1 (person)
	li	$t3, 1
	beq	$t1, $t3, drawblk1
	# check for type 2 (robot)
	li	$t3, 2
	beq	$t1, $t3, drawblk2
	# check for type 3 (rubble)
	li	$t3, 3
	beq	$t1, $t3, drawblk3
# place (person) character at object's location
drawblk1:
	li	$t3, 101 # "e"
	sb	$t3, 0($t2)
	j	drawEnd
# place (robot) character at object's location
drawblk2:
	li	$t3, 77	# "M"
	sb	$t3, 0($t2)
	j	drawEnd
# place "#" character at object's location
drawblk3:
	li	$t3, 35 # "#"
	sb	$t3, 0($t2)
	j	drawEnd
drawEnd:
	# return
	jr	$ra
	
