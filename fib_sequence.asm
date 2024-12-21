####	Final Project
####	by Zachary Sonntag
####
####	__________________________________________________Introduction__________________________________________________
####	
####	This application will ask the user for 2 integer values that will be the starting values of the FIbonacci Sequence.
####	In addition to these two integers, another integer will be asked to signify the number of iterations the program
####	should calculate in the Fibonacci Sequence. The number of iterations wiill have the constraints 3 < x < 20.
####	
####	The first integer values inputted by the user should be stored in an array, in which they will then be used to
####	determine the next value by adding them together. Then every value will be the sum of the previous 2 integers stored
####	in the array.
####
####	This program should store all values created from the Fibonacci Sequence into an array which should then be printed 
####	to the console. All output should be neat, concise, and direct. Code should be written neatly, well-documented, and
####	execute the expected results.


.data

####	Data should consist of an array, an iteration variable, user print messages.


####	Start of String print Messages

#Welcome message for the user.

	userWelcome: .asciiz "Hello! Welcome to your Fibonacci Sequence!\nTo get started, you will need to enter 2 whole number positive values. These values will start the Fibonacci Sequence.\n\n"

#First user input prompt for the first integer value of sequence.

	userInputPrompt1: .asciiz "Please enter the first whole number value you'd like your sequence to start with! (WARNING: Number MUST be a WHOLE, POSITIVE integer!):\n"

#Second user input prompt for the second integer value of sequence.

	userInputPrompt2: .asciiz "\nPlease enter your second whole number value you'd like your sequence to start with! (WARNING: Number MUST be a WHOLE, POSITIVE integer!):\n"

#Third user input prompt for the number of iterations for the Fibonacci Sequence.

	userInputPrompt3: .asciiz "\nLastly, enter a positive whole number between 3 and 20. This number represents the number of iterations your sequence will go through! (WARNING: Number MUST be a WHOLE, POSITIVE integer!):\n"

#These messages will relay the values the user has entered.

	userMessage0: .asciiz "\nYour starting values are "
	userMessage0Cont: .asciiz " and "
	userMessage1: .asciiz "\nThe number of Fibonacci Sequence iterations are "

#These messages will format and display the created Fibonacci.

	userFinalMessage0: .asciiz "\n\nYour Fibonacci Sequence is "

#Goodbye message.

	userFinalMessage1: .asciiz "\n\nThank you for using this program! Goodbye!"

#Formatting string for sequence print.

	printComma: .asciiz ", "

####	End of String print messages


####	Start of program variables

#Array with maximum space needed (Max Values = 19 max iteration + 2 user values = 21 integers, Min Value = 4 min iterations + 2 user values = 6 integers). 
#4 bytes per 32-bit integer, 4 * 21 = 84 bytes.
	
	.align 2	#Allignment was off, throwing an exception of store address not aligned.
	arraySequence: .space 84

#Variable to store the number of iterations as it will be used heavily in this program.

	iterations: .word 0
	
	
####	End of program variables



.text

#Main method

main:
	#Initializing array pointer.
	addi $s0, $zero, 0

	#Initiating welcome message.
	li $v0, 4
	la $a0, userWelcome
	syscall
	
	
	
	#Initiating prompt 1 for first sequence value from user.
	li $v0, 4
	la $a0, userInputPrompt1
	syscall
	
	#Initiating input grab.
	li $v0, 5
	syscall
	
	#Moving input into temporary register 0 (This register will be used to store the second to last value added into the array).
	move $t0, $v0
	
	
	#Saving value into the array.
	sw $t0, arraySequence($s0)
	
	#Incrementing pointer.
	addi $s0, $s0, 4
	
	
	
	#Initiating prompt 2 for second sequence value from user.
	li $v0, 4
	la $a0, userInputPrompt2
	syscall
	
	#Initiating input grab.
	li $v0, 5
	syscall
	
	#Moving input into temporary register 1 (This register will be used to store the last value added into the array).
	move $t1, $v0
	
	#Saving value into the array.
	sw $t1, arraySequence($s0)
	
	#Incrementing pointer.
	addi $s0, $s0, 4
	
	
	
	#Initiating prompt 3 for iteratiions value from user.
	li $v0, 4
	la $a0, userInputPrompt3
	syscall
	
	#Initiating input grab.
	li $v0, 5
	syscall
	
	#Moving input ito save register 1 (This register will be used to store the number of iterations for the sequence).
	move $s1, $v0
	
	#Saving the value to the iterations variable in memory.
	sw $s1, iterations
	
	
	
	#Relaying chosen values back to user.
	li $v0, 4
	la $a0, userMessage0
	syscall
	
	#Printing first sequence value.
	li $v0, 1
	addi $a0, $t0, 0
	syscall
	
	#Printing second part of userMessage0.
	li $v0, 4
	la $a0, userMessage0Cont
	syscall
	
	#Print second sequence value.
	li $v0, 1
	addi $a0, $t1, 0
	syscall
	
	#Printing iterations value back to user.
	li $v0, 4
	la $a0, userMessage1
	syscall
	
	#Printing iteration value.
	li $v0, 1
	addi $a0, $s1, 0
	syscall
	
	
	#Calling on Fibonacci method.
	jal fibonacci
	
	
	
	
	#Initiating goodbye message.
	li $v0, 4
	la $a0, userFinalMessage1
	syscall

	#Ending the program.
	li $v0, 10
	syscall

	
#Fibonacci method	
fibonacci:
	
	#Loop through the number of iterations to then store into the array.
	
	LOOP:	#Branches to PRINTARRAY if iterations are done (equal to zero).
		beq $s1, $zero, DONE
		
		#Adds previous 2 values in the Fib Sequence into $t2 register and then shifts out the previous values with the new previous values.
		add $t2, $t0, $t1
		addi $t0, $t1, 0
		addi $t1, $t2, 0
		
		#Stores the new value into the array and adjusts the pointer.
		sw $t2, arraySequence($s0)
		
		addi $s0, $s0, 4
		
		#Decreases the iterations by 1
		addi $s1, $s1, -1
		
		#Jumps back to LOOP tag.
		j LOOP
	
	DONE:
		#Prints Fibonacci Sequence message.
		li $v0, 4
		la $a0, userFinalMessage0
		syscall
		
		#Resets iterations and pointer and adds an additional 2 for user inputted values.
		lw $s1, iterations
		addi $s0, $zero, 0
		addi $s1, $s1, 2
		
	PRINTARRAY:
	
		#Loops through the array to print in a readable format.
		
		#Loads the value at memory location $s0 in the array into $t0.
		lw $t0, arraySequence($s0)
		
		#Prints $t0 to console.
		li $v0, 1
		move $a0, $t0
		syscall
		
		#Decreases number of iterations.
		addi $s1, $s1, -1
		
		#If this is the last iteration, skips printing the comma.
		beq $s1, $zero, END
		
		#Prints out to console to make output readable.
		li $v0, 4
		la $a0, printComma
		syscall
		
		#Increments the array pointer to next memory location.
		addi $s0, $s0, 4
		
		#Jumps back to the PRINTARRAY branch.
		j PRINTARRAY
	
	
	#End of the method.
	END:
	
		#Jumps back to where this method was called.
		jr $ra
