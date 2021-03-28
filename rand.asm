########################################################################
# Function Name: int rand()
########################################################################
# Functional Description:
#    This routine generates a pseudorandom number using the xorsum
#    algorithm.  It depends on a non-zero value being in the 'seed'
#    location, which can be set by a prior call to seedrand.  For this
#    version, pass in a number N in $a0.  The return value will be a
#    number between 0 and N-1.
#
########################################################################
# Register Usage in the Function:
#    $t0 -- a temporary register used in the calculations
#    $v0 -- the register used to hold the return value
#    $a0 -- the input value, N
#
########################################################################
# Algorithmic Description in Pseudocode:
#    1. Fetch the current seed value into $v0
#    2. Perform these calculations:
#   	 $v0 ^= $v0 << 13
#   	 $v0 ^= $v0 >> 17
#   	 $v0 ^= $v0 << 5
#    3. Save the resulting value back into the seed.
#    4. Mask the number, then get the modulus (remainder) dividing by $a0.
#
########################################################################
   	 .data
seed:    .word 31415   		 # An initial value, in case seedrand wasn't called
    .globl seed
    .globl rand

   	 .text
rand:
	lw   	$v0, seed   	    	# Fetch the seed value
	sll   	$t0, $v0, 13		# Compute $v0 ^= $v0 << 13
	xor   	$v0, $v0, $t0
	srl   	$t0, $v0, 17       	# Compute $v0 ^= $v0 >> 17
	xor   	$v0, $v0, $t0
	sll   	$t0, $v0, 5   	    	# Compute $v0 ^= $v0 << 5
	xor   	$v0, $v0, $t0
	sw   	$v0, seed   	    	# Save result as next seed
	andi    $v0, $v0, 0xFFFF    	# Mask the number (so we know its positive)
	div   	$v0, $a0   	    	# divide by N.  The reminder will be
	mfhi	$v0   			# in the special register, HI.  Move to $v0.
	jr	$ra   			# Return the number in $v0
