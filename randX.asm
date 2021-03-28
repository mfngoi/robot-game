########################################################################
# Function Name: int randX
########################################################################
# Functional Description:
#    This routine gets a random number for the X coordinate, so the value
#    will be between 1 and wid - 1.
#
########################################################################
# Register Usage in the Function:
#    -- Since this calls rand, we save $ra on the stack, then restore it.
#    $a0 -- the value wid - 2 passed to rand
#    $v0 -- the return value from randX
#
########################################################################
# Algorithmic Description in Pseudocode:
#    1. Save the return address on the stack
#    2. Get the value wid - 2
#    3. Pass this to rand, so we get a number between 0 and wid - 2
#    4. Add 1 to the result, so the number is between 1 and wid - 1
#    5. Restore the return address
#
########################################################################

	.data
	.globl randX
	
	.text
randX:
	# create stack and save $ra on stack
	addiu	$sp, $sp, -4
	sw	$ra, 0($sp)
	# call function rand with (wid-2) in $a0
	lw	$a0, wid
	addi	$a0, $a0, -2
	# random return value between 1 and (wid-2) in $v0
	jal	rand
	addi	$v0, $v0, 1
	# load $ra from stack and restore stack pointer
	lw	$ra, 0($sp)
	addi	$sp, $sp, 4
	#return
	jr	$ra
