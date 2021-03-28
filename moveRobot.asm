########################################################################
# Function Name: bool moveRobot(idx)
########################################################################
# Functional Description:
#    The $a0 register is the index of an object (a robot or rubble).
#    This computes and moves the robot to take one step closer to the
#    person.  If the robot crashes, it becomes rubble.  This routine returns
#    1 if the person was killed by a robot; 0 otherwise.
#
########################################################################
# Register Usage in the Function:
#    $a0 -- Index of object in question
#    $s0 -- saved index of object in question.
#    $s1 -- pointer to the object's structure.
#    $s2 -- pointer to the player's structure.
#    $t0, $t1 -- general calculations.
#    $v0 -- subroutine linkage
#
########################################################################
# Algorithmic Description in Pseudocode:
#    1. Save registers on stack
#    2. Compute pointers to object's struct and player's struct
#    3. If object is a robot:
#   	 3a. See what is in map at robot's location.  Normally it would be
#   		 the robot symbol.  But if another robot had crashed into
#   		 this one, it would be rubble.  If it is rubble, turn this
#   		 robot object into a rubble object.
#   	 3b.    Erase the robot from the map
#   	 3c. Move the robot one step vertically closer to player
#   	 3d. Move the robot one step horizontally closer to player
#   	 3e. See if there is a collision at this location
#   	 3f.    Draw robot back into map
#    4. Restore registers
#
########################################################################

	.data
	.globl moveRobot
	
	.text
moveRobot:
	# initialize address of object array and object index 
	# $t0 = object array address; $s0 = index of object
	la	$t0, objects
	move	$s0, $a0
	# create a stack to save $ra and $s0
	addiu	$sp, $sp, -16
	sw	$ra, 0($sp)
	sw	$s0, 4($sp)
	# calculate pointer to object's structure to $s1
	sll	$t1, $s0, 4
	add	$s1, $t0, $t1
	# test if object is robot, if not return
	lw	$t0, 12($s1)
	li	$t1, 2
	bne	$t0, $t1, endMoveRobot
	# store $s1 into stack
	sw	$s1, 8($sp)
	# calculate pointer to player's structure to $s2
	la	$s2, objects
	# store $s2 into stack
	sw	$s2, 12($sp)
	# test for rubble at object's location
	lw	$a0, 4($sp)
	jal	whatthere
	li	$t0, 35
	bne	$v0, $t0, notRubble
	# change object's type to 3 (rubble)
	lw	$s1, 8($sp)
	li	$t0, 3
	sw	$t0, 12($s1)
	# $v0 set to 0 due to collision
	li	$v0, 0
	j	endMoveRobot
notRubble:
	# load index into $a0 and call eraseobj
	lw	$a0, 4($sp)
	jal	eraseobj
	# fetch X value from object into $t0
	lw	$s1, 8($sp)
	lw	$t0, 4($s1)
	# fetch X value from player into $t1
	lw	$s2, 12($sp)
	lw	$t1, 4($s2)
	# compute absolute distance of X values into $t3
	sub	$t3, $t0, $t1
	bgez  	$t3, positiveX
	neg	$t3, $t3
positiveX:
	# fetch Y value from object into $t0
	lw	$t0, 8($s1)
	# fetch Y value from player into $t1
	lw	$t1, 8($s2)
	# compute absolute distance of Y values into $t4
	sub	$t4, $t0, $t1
	bgez	$t4, positiveY
	neg	$t4, $t4
positiveY:
	# load index into $a0
	lw	$a0, 4($sp)
	# test to move in direction of greater distance
	bge	$t4, $t3, moveY
	# test to move in X-axis
	lw	$t0, 4($s1)
	lw	$t1, 4($s2)
	sub	$t0, $t0, $t1
	# if $t0 is negative move robot right
	bltz	$t0, moveRight
	jal	movew
	j	checkCollision
moveRight:
	jal	movee
	j	checkCollision
# test to move in Y-axis
moveY:
	sub	$t0, $t0, $t1
	# if $t0 is negative move robot down
	bltz	$t0, moveDown
	jal	moven
	j	checkCollision
moveDown:
	jal	moves
checkCollision:
	# load index into $a0 and call whatthere
	lw	$a0, 4($sp)
	jal	whatthere
	# check collision into rubble
	li	$t0, 35	# "#"
	bne	$v0, $t0, noRubbleCollision
	# change object's type to 3 (rubble)
	lw	$s1, 8($sp)
	li	$t0, 3
	sw	$t0, 12($s1)
noRubbleCollision:
	# check collision into other robots
	li	$t0, 77 # "M"
	bne	$v0, $t0, noRobotCollision
	# change object's type to 3 (rubble)
	lw	$s1, 8($sp)
	li	$t0, 3
	sw	$t0, 12($s1)
noRobotCollision:
	# check collision into player
	li	$t0,101 # "e"
	bne	$v0, $t0, noPlayerCollision
	li	$v0, 1
	j	endMoveRobot
noPlayerCollision:
	li	$v0, 0
endMoveRobot:
	# load index into $a0 and call drawobj
	lw	$a0, 4($sp)
	jal	drawobj
	# restore $ra, fix stack, and return
	lw	$ra, 0($sp)
	addi	$sp, $sp, 16
	jr	$ra
	
