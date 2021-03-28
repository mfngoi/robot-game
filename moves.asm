########################################################################
# Function Name: moves(idx)
########################################################################
# Functional Description:
#    This routine moves one object south on the board (down the page).
#    The $a0 register is the index of the object to move.
#
########################################################################
# Register Usage in the Function:
#    $a0 -- Index of object to move
#    $t0, $t1, $t2 -- general calculations.
#
########################################################################
# Algorithmic Description in Pseudocode:
#    1. Compute the effective address of the object
#    2. Increment the Y value
#    3. Increment the pointer by the line length
#
########################################################################

	.data
	.globl moves
	
	.text
moves:
	# initialize address of object array and object index 
	# $t0 = object array address; $t1 = index of object
	la	$t0, objects
	move	$t1, $a0
	# calculate pointer to object's structure to $t0
	sll	$t1, $t1, 4
	add	$t0, $t0, $t1
	# increment the object's Y value
	lw	$t1, 8($t0)
	addi	$t1, $t1, 1
	sw	$t1, 8($t0)
	# increment the object's location by line length
	lw	$t2, linelen
	lw	$t1, 0($t0)
	add	$t1, $t1, $t2
	sw	$t1, 0($t0)
	# return
	jr	$ra