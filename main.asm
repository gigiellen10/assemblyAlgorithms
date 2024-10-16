# program to compute the fibbonaci sequence of a number (recursive and iterative
# , and implement binary search algorithm

# data declarations

.data 
FIB_MSSG: .asciiz "Enter an integer to compute the fibbonacci sequence for: "
FIB_OUTPUT_ITER: .asciiz "The result of the iterative fib sequence is: "
FIB_OUTPUT_REC: .asciiz "The result of the recursive fib sequence is: "
DONE: .asciiz "\nProgram terminating!"

fib_num: .space 20

# program code in following section

.text
.globl main # had main label with colon but was erroring

# iterative fib 
FIB_ITER:
    addi $v0, $zero, 1021
    jr $ra

main:

# prompt user for a number to compute the fib sequence of
    li $v0, 4 # print string syscall is 4
    la $a0, FIB_MSSG # load addy of message to print
    syscall 

# get user input for number to compute fib sequence of 
    li $v0, 5 # 5 = syscall for read integer
    syscall # read user input into $v0
    add $a0, $zero, $v0 # load into adress register to be used in fib function

# call fib function -> iterative first, then recursive
    jal FIB_ITER
    add $v1, $zero, $v0 # take result from v0 and store to v1 so we can syscall with v0
    la $a0, FIB_OUTPUT_ITER # print output for iterative fun
    li $v0, 4 # code = 4 to print string
    syscall 
    li $v0, 1 # code = 1 to print integer
    add $a0, $zero, $v1 # move previously computed result from v1 to a0 for print
    syscall # print result from iter fib() from reg. v1






la $a0, DONE
li $v0, 4
syscall 

# terminate program
    li $v0, 10
    syscall 

.end main