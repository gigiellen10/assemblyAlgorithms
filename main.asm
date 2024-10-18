# program to compute the fibbonaci sequence of a number (recursive and iterative
# , and implement binary search algorithm

# data declarations

.data 
FIB_MSSG: .asciiz "Enter an integer to compute the fibbonacci sequence for: "
FIB_OUTPUT_ITER: .asciiz "The result of the iterative fib sequence is: "
FIB_OUTPUT_REC: .asciiz "\nThe result of the recursive fib sequence is: "
PROMPT_NUMBER: .asciiz "\nEnter integer #" # first part of prompting user for an array of 10
CONTINUE_PROMPT_NUMBER: .asciiz " in SORTED ORDER to be used in input array of size 10: " # second part of prompting user for an array of 10
DONE: .asciiz "\nProgram terminating!" # for ensuring proper exit of program

fib_num: .space 20
arr: .word 0:10 # integer array of size 10, elements init to 0

# program code in following section

.text
.globl main # had main label with colon but was erroring

# iterative fib 
FIB_ITER:
# check base case (n <= 1) return n; -> 1 < n
    addi $t2, $zero, 1 # create temp with 1 to compare to argument n
    slt $t3, $t2, $a0 # if t2/ 1 < a0/ n, set flag = true (1)
    bne $zero, $t3, IF # base case not satisfied, flag = 0, continue to loop

# n is not valid, return n
    add $t2, $zero, $a0 # t2 will eventually be returned as result at END
    j RETURN_FIB_ITER # go to where we store the result 

# n is valid, compute fib
    IF:
        # init vars
        addi $t2, $zero, 0 # set t2 = 0, t2 will be the result of fib sum
        addi $t0, $zero, 0 # prev1 = 0
        addi $t1, $zero, 1 # prev2 = 1
        addi $t3, $zero, 2 # i = 2
    
    loop: slt $t4, $a0, $t3 # check if n < i
        bne $t4, $zero, RETURN_FIB_ITER # break loop if flag = true
        add $t2, $t0, $t1 # result = prev1 + prev2
        add $t0, $zero, $t1 # prev1 = prev2
        add $t1, $zero, $t2 # prev2 = result
        addi $t3, $t3, 1 # increment i, ++i
        j loop

    RETURN_FIB_ITER:
        add $v0, $zero, $t2 # put result (t2) into return register
        jr $ra

# recursive fib sequence
FIB_REC:
   # check base case (n <= 1) return n 
    addi $t0, $zero, 1 # create temp to hold 1 for comparison
    slt $t1, $t0, $a0 # 1 < n
    bne $zero, $t1, recursion
    add $v0, $zero, $a0 # return n
    jr $ra
 
    recursion:
    # allocate stack frame and save return addy
    addi $sp, $sp, -12
    sw $ra, 0($sp)

    # save arguments needed after call
    sw $a0, 4($sp) # save n
    addi $a0, $a0, -1 # compute argument for n - 1
    # make recursive call
    jal FIB_REC

    # restore register values needed after call
    lw $a0, 4($sp) # restore n 

    # we are going to make another call, but need to save
    # result of fib(n-1) first!
    sw $v0, 8($sp)
    
    addi $a0, $a0, -2 # compute argument for n - 2
    jal FIB_REC

    # add return value of fib(n-2) to prev saved from n - 1
    lw $t1, 8($sp) # save in temp, then add to v0
    add $v0, $v0, $t1 # result = fib(n - 1) + fib (n - 2)

    # put ra saved in stack back into $ra
    lw $ra, 0($sp)
    addi $sp, $sp, 12 # pop 3 items off the stack

    jr $ra # return fib sum

# ************* MAIN STARTS HERE ************
main:

# prompt user for a number to compute the fib sequence of
    li $v0, 4 # print string syscall is 4
    la $a0, FIB_MSSG # load addy of message to print
    syscall 

# get user input for number to compute fib sequence of 
    li $v0, 5 # 5 = syscall for read integer
    syscall # read user input into $v0
    addi $sp, $sp, -4 # make room to store 
    sw $v0, 0($sp) # save user input to be used later in recursive version of fib
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

# call fib recursive
    lw $a0, 0($sp) # load saved n taken from user into $a0 for argument to recursive fib
    addi $sp, $sp, 4 # put stack back to previous position
    jal FIB_REC
    add $v1, $zero, $v0 # take result from v0 and store to v1 so we can syscall with v0
    la $a0, FIB_OUTPUT_REC # print output for recursive fun
    li $v0, 4 # code = 4 to print string
    syscall 
    li $v0, 1 # code = 1 to print integer
    add $a0, $zero, $v1 # move previously computed result from v1 to a0 for print
    syscall # print result from iter fib() from reg. v1

# prompt user for an array of size 10 and perform binary search -- note: no error checking on user input
    
    addi $t0, $zero, 0 # i = index to array
    addi $t2, $zero, 0 # count = counter for controlling loop
    
    input_loop: slti $t1, $t2, 10 # if (count < 10) flag = 1 -> 10 iterations
        beq $t1, $zero, END_INPUT_LOOP # case where flag = 0, done with reading integers
        addi $v0, $zero, 4 # print mssg for getting integer number n
        la $a0, PROMPT_NUMBER # load first part of mssg
        syscall 
        addi $v0, $zero, 1 # print k, where k is the kth integer we've loaded into our array so far (0 indexing)
        add $a0, $zero, $t2 # argument to print
        syscall
        addi $v0, $zero, 4 # print mssg for getting integer number n
        la $a0, CONTINUE_PROMPT_NUMBER # load first part of mssg
        syscall # finish prompt

        # load integer input into corresponding index in array
        addi $v0, $zero, 5 # 5 = syscall for read integer
        syscall # read user input into $v0
        add $t3, $zero, $v0
        sw $t3, arr($t0) # arr[i] = user_input

        addi $t0, $t0, 4 # ++i, update 4 bytes to go to next index
        addi $t2, $t2, 1 # ++count
        j input_loop
    
    END_INPUT_LOOP: 
        # load arguments for BS
        # call binary search function


# print end mssg 
    la $a0, DONE
    li $v0, 4
    syscall 

# terminate program
    li $v0, 10
    syscall 

.end main
