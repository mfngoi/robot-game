########################################################################
# Function Name: bool robotAlive(idx)
########################################################################
# Functional Description:
#    The $a0 register is the index of an object (a robot or rubble).
#    Finds the type in the object structure and returns 1 if the object
#    is a robot, and returns 0 if anything else. 
#
########################################################################
# Register Usage in the Function:
#    $a0 -- Index of object in question
#    $t0, $t1 -- general calculations.
#    $v0 -- subroutine linkage
#
########################################################################
# Algorithmic Description in Pseudocode:
#    1. Compute the effective address of the object
#    2. Determine the object type
#    3. Return 0 if not a robot, and 1 if robot
#
########################################################################

	.data
	.globl robotAlive
	
	.text
robotAlive:
	# initialize address of object array and object index 
	# $t0 = object array address; $t1 = index of object
	la	$t0, objects
	move	$t1, $a0
	# calculate pointer to object's structure to $t0
	sll	$t1, $t1, 4
	add	$t0, $t0, $t1
	# load object's type into $t1
	lw	$t1, 12($t0)
	# test if type is robot
	addi	$t1, $t1, -2
	bnez	$t1, notAlive
	li	$v0, 1
	jr	$ra
notAlive:
	li	$v0, 0
	jr	$ra