.data

A:			.space 80  	# create integer array with 20 elements ( A[20] )
size_prompt:		.asciiz 	"Enter array size (between 1 and 20): "
array_prompt:		.asciiz 	"A["
sorted_array_prompt:	.asciiz 	"Sorted A["
close_bracket: 		.asciiz 	"] = "
search_prompt:		.asciiz		"Enter search value: "
not_found:		.asciiz		" not in sorted A"
newline: 		.asciiz 	"\n" 	

.text

main:	
	# ----------------------------------------------------------------------------------
	# Do not modify
	#
	# MIPS code that performs the C-code below:
	#
	# 	int A[20];
	#	int size = 0;
	#	int v = 0;
	#
	#	printf("Enter array size [between 1 and 20]: " );
	#	scanf( "%d", &size );
	#
	#	for (int i=0; i<size; i++ ) {
	#
	#		printf( "A[%d] = ", i );
	#		scanf( "%d", &A[i]  );
	#
	#	}
	#
	#	printf( "Enter search value: " );
	#	scanf( "%d", &v  );
	#
	# ----------------------------------------------------------------------------------
	
	la $16, A			# store address of array A in $16
  
	add $17, $0, $0			# create variable "size" ($17) and set to 0
	add $18, $0, $0			# create search variable "v" ($18) and set to 0
	add $8, $0, $0			# create variable "i" ($8) and set to 0

	addi $2, $0, 4  		# system call (4) to print string
	la $4, size_prompt 		# put string memory address in register $4
	syscall           		# print string
  
	addi $2, $0, 5			# system call (5) to get integer from user and store in register $2
	syscall				# get user input for variable "size"
	add $17, $0, $2		        # copy to register $17, b/c we'll reuse $2
  
prompt_loop:
	# ----------------------------------------------------------------------------------
	slt $9, $8, $17		# if( i < size ) $9 = 1 (true), else $9 = 0 (false)
	beq $9, $0, end_prompt_loop	 
	sll $10, $8, 2			# multiply i * 4 (4-byte word offset)
				
  	addi $2, $0, 4  		# print "A["
  	la $4, array_prompt 			
  	syscall  
  	         			
  	addi $2, $0, 1			# print	value of i (in base-10)
  	add $4, $0, $8			
  	syscall	
  					
  	addi $2, $0, 4  		# print "] = "
  	la $4, close_bracket		
  	syscall					
  	
  	addi $2, $0, 5			# get input from user and store in $2
  	syscall 			
	
	add $11, $16, $10		# A[i] = address of A + ( i * 4 )
	sw $2, 0($11)			# A[i] = $2 
	addi $8, $8, 1		        # i = i + 1
		
	j prompt_loop			# jump to beginning of loop
	# ----------------------------------------------------------------------------------	
end_prompt_loop:

	addi $2, $0, 4  		# print "Enter search value: "
  	la $4, search_prompt 			
  	syscall 
  	
  	addi $2, $0, 5			# system call (5) to get integer from user and store in register $2
	syscall				# get user input for variable "v"
	add $18, $0, $2		        # copy to register $18, b/c we'll reuse $2

	# ----------------------------------------------------------------------------------
	# TODO:	PART 1
	#	Write the MIPS-code that performs the the C-code (bubble sort) shown below.
	#	The above code has already created array A and A[0] to A[size-1] have been 
	#	entered by the user. After the bubble sort has been completed, the values in
	#	A are sorted in increasing order, i.e. A[0] holds the smallest value and 
	#	A[size -1] holds the largest value.
	#	
	#	int t = 0;
	#	
	#	for ( int i=0; i<size-1; i++ ) {
	#		for ( int j=0; j<size-1-i; j++ ) {
 	#			if ( A[j] > A[j+1] ) {
	#				t = A[j+1];
	#				A[j+1] = A[j];
	#				A[j] = t;
	#			}
	#		}
	#	}
	#			
	# ----------------------------------------------------------------------------------
	
	#dont overwrite 16 (s0), 17 (s1), 18
	add $12, $0, $0			# i = 0
	

loopOut:

	subi $13, $17, 1	
				
	bge $20, $13, endLoopOut 
			
	add $21, $0, $0				
	
loopIn: 

	sub $8, $17, $20 
				
	subi $8, $8, 1 	
				
	bge $21, $8, endLoopIn 		


	sll $9, $21, 2	
				
	addi $10, $9, 4 	
			
	add $9, $16, $9 	
			
	add $10, $16, $10 			

	lw $12, 0($9) 	
				
	lw $14, 0($10) 	
				

	ble $12, $14, noSwap 	
			
	sw $12, 0($10)
	
	sw $14, 0($9)

noSwap:

	addi $21, $21, 1 
				
	j loopIn

endLoopIn:
	addi $20, $20, 1 
				
	j loopOut

endLoopOut:
	
	# ----------------------------------------------------------------------------------
	# TODO:	PART 2
	#	Write the MIPS-code that performs the C-code (binary search) shown below.
	#	The array A has already been sorted by your code above in PART 1, where A[0] 
	#	holds the smallest value and A[size -1] holds the largest value, and v holds 
	# 	the search value entered by the user
	#	
	#	int left = 0;
	# 	int right = size - 1;
	#	int middle = 0;
	#	int element_index = -1;
 	#
	#	while ( left <= right ) { 
      	#
      	#		middle = left + (right - left) / 2; 
	#
      	#		if ( A[middle] == v) {
      	#    			element_index = middle;
      	#    			break;
      	#		}
      	#
      	#		if ( A[middle] < v ) {
      	#    			left = middle + 1; 
      	#		} else {
      	#    			right = middle - 1;
    	#		} 
	#	}
	#
	#	if ( element_index < 0 ) {
    	#		printf( "%d not in sorted A\n", v );
    	#	} else {
    	#		printf( "Sorted A[%d] = %d\n", element_index, v );
    	#	}
	# ----------------------------------------------------------------------------------
	
	addi $21, $0, 0				
	
	addi $22, $17, -1		
		
	addi $23, $0, -1			
	
	addi $24, $0, 0				
	
	

loopStart:
	bgt $21, $22, Break 


	sub $8, $22, $21 
				
	sra $9, $8, 1 	
				
	add $24, $21, $9 			

	sll $9, $24, 2
	
	add $9, $9, $s0
	
	lw $10, 0($9) 


	beq $10, $18, Equals 	
		
	blt $10, $18, Right		

	addi $22, $24, -1
			
	j loopStart
	

Equals:

	add $23, $0, $24
			
	j Break

Right:			
		
	addi $21, $24, 1
	
	j loopStart

Break:
	beq $23, -1 notExist

	la $4, sorted_array_prompt	
	
	addi $2, $0, 4
	
	syscall

	add $4, $0, $23
	
	addi $2, $0, 1
	
	syscall
	
	la $4, close_bracket
			
	addi $2, $0, 4
	
	syscall
 	
 	add $4, $0, $18
 	
	addi $2, $0, 1
	
	syscall
	

	j exit

notExist:

	add $4, $0, $18
	
	addi $2, $0, 1
	
	syscall

	la $4, not_found
			
	addi $2, $0, 4
	
	syscall

	j exit
  	
  	
  	
  	
  	
  	
# ----------------------------------------------------------------------------------
# Do not modify the exit
# ----------------------------------------------------------------------------------
exit:                     
  addi $2, $0, 10      		# system call (10) exits the program
  syscall               	# exit the program
  
