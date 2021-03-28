########################################################################
# Function Name: int randY
########################################################################
# Functional Description:
#    This routine gets a random number for the Y coordinate, so the value
#    will be between 1 and hgt - 1.
#
########################################################################
# Register Usage in the Function:
#    -- Since this calls rand, we save $ra on the stack, then restore it.
#    $a0 -- the value hgt - 2 passed to rand
#    $v0 -- the return value from randY
#
########################################################################
# Algorithmic Description in Pseudocode:
#    1. Save the return address on the stack
#    2. Get the value hgt - 2
#    3. Pass this to rand, so we get a number between 0 and hgt - 2
#    4. Add 1 to the result, so the number is between 1 and hgt - 1
#    5. Restore the return address
#
########################################################################

	.data
	.globl randY
	
	.text
randY:
	# create stack and save $ra on stack
	addiu	$sp, $sp, -4
	sw	$ra, 0($sp)
	# call function rand with (hgt-2) in $a0
	lw	$a0, hgt
	addi	$a0, $a0, -2
	# random return value between 1 and (hgt-2) in $v0
	jal	rand
	addi	$v0, $v0, 1
	# load $ra from stack and restore stack pointer
	lw	$ra, 0($sp)
	addi	$sp, $sp, 4
	#return
	jr	$ra

