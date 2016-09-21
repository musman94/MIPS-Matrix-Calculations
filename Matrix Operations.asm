.globl main
.text


main:
la $a0,user
li $v0,4
syscall
li $v0,5
syscall
beq $v0,1,create_matrix
beq $v0,2,create_value
beq $v0,3,display_matrix
beq $v0,4,display_value
beq $v0,5,check_eq


######### part 1 ##########
#creating the matrices and inputting the values
create_matrix:
la $a0,row1
li $v0,4
syscall
li $v0,5
syscall
move $s0,$v0		#$s0 has the no. of rows of first matrix
la $a0,column1
li $v0,4
syscall
li $v0,5		#s1 has the no. of columns of first matrix
syscall
move $s1,$v0
mul $t0,$s0,$s1
move $s2,$t0          
mul $a0,$t0,4		#s2 has the total no. of elements of the first matrix
li $v0,9
syscall
move $s3,$v0           	#s3 has the base address of heap
la $a0,row2
li $v0,4
syscall
li $v0,5
syscall
move $s4,$v0		#$s4 has the no. of rows of the second matrix
la $a0,column2
li $v0,4
syscall
li $v0,5		#s5 has the no. of columns of the second matrix
syscall
move $s5,$v0
mul $t0,$s4,$s5
move $s6,$t0            #s6 has the total no. of elements of second matrix
mul $a0,$t0,4
li $v0,9
syscall
move $s7,$v0           	#s7 has the base address of heap of second matrix
la $a0,matrix_done
li $v0,4
syscall


input_values:		#part for inputting the values in the matrix
li $t9,-1
la $a0,input1
li $v0,4
syscall
move $t0,$s3
li $t1,0
input1_loop:		#for the first matrix
li $v0,6
syscall
s.s $f0,0($t0)
addi $t0,$t0,4
addi $t1,$t1,1
beq $t1,$s2,input_done
j input1_loop


second_input:		#for the second matrix
li $t9,1
la $a0,input2
li $v0,4
syscall
move $t0,$s7
li $t1,0
input2_loop:
li $v0,6
syscall
s.s $f0,0($t0)
addi $t0,$t0,4
addi $t1,$t1,1
beq $t1,$s6,input_done
j input2_loop

input_done:
la $a0,input_done_line	#executed when values have been entered successfully
li $v0,4
syscall
beq $t9,-1,second_input
j main
##########part 1 done########


######### part 2 ###########
#inputting a user defined value in the matrix 
create_value:
la $a0,input_select
li $v0,4
syscall
li $v0,5
syscall
beq $v0,2,change_second
li $t7,-1			#changing the value in the first matrix
jal intermed1
la $a0,enter_new
li $v0,4
syscall
li $v0,6
syscall
s.s $f0,0($t0)
la $a0,value_changed
li $v0,4
syscall
li $t7,1
j main
change_second:			#changing the value in the second matrix
li $t7,-1			
jal intermed2
la $a0,enter_new
li $v0,4
syscall
li $v0,6
syscall
s.s $f0,0($t0)
la $a0,value_changed
li $v0,4
syscall
li $t7,1
j main
##########part 2 done########


######### part 3 ###########
#displaying the matrix
display_matrix:
la $a0,input_select
li $v0,4
syscall
li $v0,5
syscall
beq $v0,2,display_second
li $t0,0			#controls the outer loop
li $t1,0			#controls the inner loop
move $t3,$s3			#displaying the first matrix
display_loop1:
l.s $f12,0($t3)
li $v0,2
syscall
la $a0,tab
li $v0,4
syscall
addi $t3,$t3,4
addi $t1,$t1,1
bne $t1,$s1,display_loop1
la $a0,newline
li $v0,4
syscall
addi $t0,$t0,1
li $t1,0
bne  $t0,$s0,display_loop1
j  main


display_second:
li $t0,0			#controls the outer loop
li $t1,0			#controls the inner loop
move $t3,$s7			#displaying the second matrix
display_loop2:
l.s $f12,0($t3)
li $v0,2
syscall
la $a0,tab
li $v0,4
syscall
addi $t3,$t3,4
addi $t1,$t1,1
bne $t1,$s5,display_loop2
la $a0,newline
li $v0,4
syscall
addi $t0,$t0,1
li $t1,0
bne  $t0,$s4,display_loop2
j  main
######### part 3 done ###########

######### part 4 ###########
#displaying the particular value user asks for
display_value:
la $a0,input_select
li $v0,4
syscall
li $v0,5
syscall
beq $v0,2,value_2
intermed1:
la $a0,value_row
li $v0,4
syscall
li $v0,5
syscall
move $t0,$v0			#t0 has the row no.
la $a0,value_column
li $v0,4
syscall
li $v0,5
syscall
move $t1,$v0			#t1 has the column no.
addi $t0,$t0,-1
mul $t0,$t0,$s1
addi $t1,$t1,-1
add $t0,$t0,$t1
mul $t0,$t0,4
add $t0,$t0,$s3
beq $t7,-1,go_back
l.s $f12,0($t0)			#f12 contains the required value
li $v0,2
syscall
la $a0,newline
li $v0,4
syscall
j main
value_2:			#displaying the value in the second matrix
intermed2:
la $a0,value_row
li $v0,4
syscall
li $v0,5
syscall
move $t0,$v0			#t0 has the row no.
la $a0,value_column
li $v0,4
syscall
li $v0,5
syscall
move $t1,$v0			#t1 has the column no.
addi $t0,$t0,-1
mul $t0,$t0,$s5
addi $t1,$t1,-1
add $t0,$t0,$t1
mul $t0,$t0,4
add $t0,$t0,$s7
beq $t7,-1,go_back
l.s $f12,0($t0)			#f12 contains the required value
li $v0,2
syscall
la $a0,newline
li $v0,4
syscall
j main
go_back:
jr $ra
######### part 4 done ###########

######### part 5 ###########
check_eq:
seq $t0,$s0,$s4
seq $t1,$s1,$s5
and $t0,$t0,$t1
bne $t0,1,not_eq

move $t0,$s3
move $t1,$s7
li $t2,0
check_loop:
l.s $f1,0($t0)
l.s $f2,0($t1)
c.eq.s $f1,$f2
bc1f not_eq
addi $t0,$t0,4
addi $t1,$t1,4
addi $t2,$t2,1
bne $t2,$s0,check_loop
la $a0,equal_line
li $v0,4
syscall
j main

not_eq:
la $a0,not_eq_line
li $v0,4
syscall
j main

######### part 5 done ###########

######### part 6  ###########









######### part 6 done ###########





.data
user: .ascii "1- Create Matrix\n"
	     "2- Create Values\n"
	     "3- Display Matrix\n"
	     "4- Display Value\n"
	     "5- Check if the two matrices are equal\n"
	     "6- Calculate the transpose of the matrix\n"
newline: .asciiz "\n"	     
row1: .asciiz "Please enter the no. of rows of the first matrix:\n"
column1: .asciiz "Please enter the no. of columns of the first matrix\n"
row2: .asciiz "Please enter the no. of rows of the second matrix:\n"
column2: .asciiz "Please enter the no. of columns of the second matrix\n"
input_select: .asciiz "Please select the matrix, 1 or 2?\n"
input1: .asciiz "Please enter the values for the first matrix: \n"
input2: .asciiz "Please enter the values for the second matrix: \n"
matrix_done: .asciiz "Matrix has been made\n"
input_done_line: .asciiz "Inputting has been done\n"
tab: .asciiz "\t"
value_row: .asciiz "Enter the row no: \n"
value_column: .asciiz "Enter the column no: \n"
enter_new: .asciiz "Please enter the new value: \n"
value_changed: .asciiz "The value has been changed: \n"
equal_line: .asciiz "The matrices are equal\n"
not_eq_line: .asciiz "The matrices are not equal\n"

	     
	     
