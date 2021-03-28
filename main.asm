########################################################################
# Program: Robots Final Project			Programmer: Matthew Ngoi
# Due Date: 8 December 2020			Course: CS2640
########################################################################
# Overall Program Functional Description:
#       The game board is filled with electrified walls and malicious, 
#    but dumb, robots.  On each turn, you move one step, then all the 
#    robots take one step towards you.  If the robots hit a wall, 
#    other robots, or piles of rubble, they crash and become rubble. 
#    If you hit a wall or a robot, or rubble, you die.  If all of 
#    the robots crash, you win!
#    The robot: "M"	The player: "e"
#    Your moves are: 	w -- move up,  
#			s -- move down,  
#			a -- move left,  
#			d -- move right,  
#			p -- (pause) stand still, and 
#			j -- jump to a random location.
#
########################################################################
# Register usage in Main:
#    $a0, $a1 -- subroutine input
#    $t0, $t1 -- general calculations.
#    $v0 -- subroutine linkage
#
########################################################################
# Pseudocode Description:
#    1. Display title screen
#    2. Prompt user to enter seed
#       2a. store value in seed 
#    3. Initialize board and add walls
#    4. Create person object in object array
#        4a. placeobj with index 0
#        4b. drawobj with index 0
#    5. Loop to create robot objects
#        5a. placeobj with index n
#        5b. drawobj with index n
#    6. Start game loop
#        6a. draw board onto console
#        6b. players turn and check for collisions
#        6c. loop for robot's turn
#           6ci. check if robot is alive and increment alive counter
#	    6cii. move robot and check for collisions
#	    6ciii. increament index and loop robot turn
#    7. Check for amount of robots alive
#    8. Loop back to game loop
#    9. Jump to end if collision occurs or condition is satisfied
#
########################################################################

	.data
welcome:	.asciiz "\nWelcome to Matthew Ngoi's Robot Game!\n"
instruction:	.asciiz "\nThe robot: \"M\"	The player: \"e\"\nYour moves are:\nw -- move up,\ns -- move down,\na -- move left,\nd -- move right,\np -- (pause) stand still, and\nj -- jump to a random location\n"
enter:		.asciiz "\nEnter a seed for the program: "
pmove:		.asciiz "\nYour move: "
nline:		.asciiz "\n"
win:		.asciiz "\nYou win!"
lose:		.asciiz	"\nRobots have won!"
inputError:	.asciiz "\nTry again. Enter an appropriate command."
robotDefeated:	.asciiz	"\nAll robots are defeated."
playerRobot:	.asciiz "\nYou have run into a robot."
playerRubble:	.asciiz "\nYou have run into some rubble."
robotPlayer:	.asciiz "\nA robot has caught you."
endLine:	.asciiz "\nThank you for playing!"
		.align 2
wid:		.word 39
hgt:		.word 30
linelen:	.word 40
boardlen:	.word 1200
numwalls:	.word 50
numrobots:	.word 20
board:		.space 1204
objects:	.space 800
buffer:		.space 4
	.globl	nline
	.globl	wid
	.globl	hgt
	.globl	linelen
	.globl	boardlen
	.globl	numwalls
	.globl	numrobots
	.globl	board
	.globl	objects
	.globl	buffer

	.text
main:	
	# display title screen
	li	$v0, 4
	la	$a0, welcome
	syscall
	li	$v0, 4
	la	$a0, instruction
	syscall
	# enter seed
	li	$v0, 4
	la	$a0, enter
	syscall
	li	$v0, 5
	syscall
	# if input == 0, then default seed is used
	beqz	$v0, dseed
	move	$a0, $v0
	jal	seedrand
dseed:
	# initalize board and add walls
	jal	initBoard
	jal	addWalls
	# create person object
	li	$a0, 0
	li	$a1, 1
	jal	placeobj
	# draw person at index 0
	li	$a0, 0
	jal	drawobj
	# initialize beginning of index
	li	$a0, 1
	# create stack and store index
	addiu	$sp, $sp, -8
	sw	$a0, 0($sp)
# loop to create robots
robotLoop:
	# place and draw robot
	lw	$a0, 0($sp)
	li	$a1, 2
	jal	placeobj
	lw	$a0, 0($sp)
	jal	drawobj
	# increment loop and test
	lw	$a0, 0($sp)
	addi	$a0, $a0, 1
	sw	$a0, 0($sp)
	# initialize counter
	lw	$t0, numrobots
	ble	$a0, $t0, robotLoop
mainLoop:
	# print board
	li	$v0, 4
	la	$a0, nline
	syscall
	li	$v0, 4
	la	$a0, board
	syscall
# fetch player's move
playerTurn:
	li	$v0, 4
	la	$a0, pmove
	syscall
	li	$v0, 8
	la	$a0, buffer
	li	$a1, 2
	syscall						
	# eraseObj(0)
	li	$a0, 0
	jal	eraseobj
	# get first character of buffer into $t1
	la	$t0, buffer
	lb	$t1, 0($t0)
	# switch for player options
	li	$t2, 119 #w
	beq	$t1, $t2, blk1
	li	$t2, 115 #s
	beq	$t1, $t2, blk2
	li	$t2, 97 #a
	beq	$t1, $t2, blk3
	li	$t2, 100 #d
	beq	$t1, $t2, blk4
	li	$t2, 106 #j
	beq	$t1, $t2, blk5
	li	$t2, 112 #p
	beq	$t1, $t2, blk6
	li	$t2, 113 #q
	beq	$t1, $t2, end
	# default case
	# exception handling for incorrect input
	j	exceptionInput
blk1: #w
	jal	moven
	j	checkmove
blk2: #s
	jal	moves
	j	checkmove
blk3: #a
	jal	movew
	j	checkmove
blk4: #d
	jal	movee
	j	checkmove
blk5: #j
	jal	movej
	li	$a0, 0
	j	checkmove
blk6: #p
	j	skipTurn
# tests player's move for any end conditions
checkmove:
	jal	whatthere
	# checks if player ran into robot
	li	$t0, 77
	beq	$v0, $t0, playerIntoRobot
	# checks if player ran into rubble
	li	$t0, 35
	beq	$v0, $t0, playerIntoRubble
skipTurn:
	jal	drawobj
	# initialize robot index and store into stack
	li	$a0, 1
	sw	$a0, 0($sp)
	# initialize alive counter and store into stack
	li	$t0, 0
	sw	$t0, 4($sp)
# loop through robots and move towards player	
robotTurn:
	# check if robot is alive
	lw	$a0, 0($sp)
	jal	robotAlive
	beqz	$v0, robotDead
	# increment alive counter
	lw	$t0, 4($sp)
	addi	$t0, $t0, 1
	sw	$t0, 4($sp)
	# call moveRobot
	lw	$a0, 0($sp)
	jal	moveRobot	
	# if robots hit player, then end
	bnez	$v0, robotCatchesPlayer
robotDead:
	# increment loop and test
	lw	$a0, 0($sp)
	addi	$a0, $a0, 1
	sw	$a0, 0($sp)
	# initialize counter
	lw	$t0, numrobots
	ble	$a0, $t0, robotTurn
	### at this point all robots have done their turn ###
	# checks if any robots are left alive
	lw	$t0, 4($sp)
	beqz	$t0, allRobotsDefeated
	j	mainLoop
# end condition for player defeating all robots
allRobotsDefeated:
	### condition statement ###
	li	$v0, 4
	la	$a0, robotDefeated
	syscall
	j	playerWins	
# end condition for player running into robot
playerIntoRobot:
	### condition statement ###
	li	$v0, 4
	la	$a0, playerRobot
	syscall
	j	robotWins
# end condition for player running into rubble
playerIntoRubble:
	### condition statement ###
	li	$v0, 4
	la	$a0, playerRubble
	syscall
	j	robotWins
# end condition for robot catching player
robotCatchesPlayer:
	### condition statement ###
	li	$v0, 4
	la	$a0, robotPlayer
	syscall
	j	robotWins
# player wins end card
playerWins:
	li	$v0, 4
	la	$a0, win
	syscall
	j	end
# robot wins end card
robotWins:
	li	$v0, 4
	la	$a0, lose
	syscall
	j	end
# restore stack and quit program
end:	
	addiu	$sp, $sp, 8
	li	$v0, 4
	la	$a0, endLine
	syscall
	li	$v0, 10
	syscall
# prints exception error and loops back to fetch
#    to fetch player's input
exceptionInput:
	li	$v0, 4
	la	$a0, inputError
	syscall
	j	playerTurn
	
