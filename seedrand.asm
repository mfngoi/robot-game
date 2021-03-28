########################################################################
# Function Name: seedrand(int)
########################################################################
# Functional Description:
#    This routine sets the seed for the random number generator.  The
#    seed is the number passed into the routine.
#
########################################################################
# Register Usage in the Function:
#    $a0 -- the seed value being passed to the routine
#
########################################################################

	.data
	.globl seedrand

	.text
seedrand:
	sw	$a0, seed
	jr 	$ra
