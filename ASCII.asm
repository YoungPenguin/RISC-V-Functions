# This program can convert an ASCII string contaning a posetive or negative integer decimal string to an integer.

# The code uses 5 registers a0-a4, 2 save registers s0-s1, and two temporary registers t0-t1.
# Register a4 is used to check if the number contains a positive or negative sign with the ASCII
# numbers for ”-” and ”+” (positive: 43, negative: 45).
# Register a3 is then used as a flag to tell if it’s positive or negative.


.data
string:
.asciiz "-123"      #number

.text
    la a0, string       # Loads address
    lb a1, 0(a0)        # Loads data from address
    add a2, zero, zero  # Result
    add t0, zero, zero  # Counter = 0
    add s0, zero, zero  # Address + Counter
    addi s1, zero, 10   # sets s1 to 10
    addi t1, zero, 1   
    add t2, zero, zero
    add a3, zero, zero  # flag 

    addi a4, zero, 43   #check for posetive sign (43)
    beq a1, a4, positive
    addi a4, zero, 45   #check for negative sign (45)
    beq a1, a4, negative
    j getLength         #if there's no sign

negative:
    addi a0, a0, 1
    addi a3, zero, 1    #add 1 to flag
    lb a1, 0(a0)        # Loads data from address
    j getLength

positive:
    addi a0, a0, 1
    lb a1, 0(a0)       # Loads data from address
    j getLength

getLength:
    beq a1, zero, main      # Checks if null
    addi a1, a1, -48        # Converts from ASCII to decimal by subtracting 48
    bgeu a1, s1, exitFail   
    addi t0, t0, 1          # Counter + 1
    add s0, t0, a0          
    lb a1, 0(s0)            
    j getLength
    
main:
    addi t0, t0, -1     
    add s0, t0, a0      # Address + Counter
    lb a1, 0(s0)        
    addi a1, a1, -48    # Converts from ASCII to decimal by subtracting 48
    mul t2, t1, a1      
    mul t1, t1, s1      
    add a2, a2, t2      # multiplying a2 with our constant 10 because there is no "muli" instruction
    bgt t0, zero, main
    j exitSucces
    
exitFail:
    addi x10, zero, 1 
    nop

exitSucces:
    addi x10, a2, 0  
    beq a3, zero, end
    sub x10, x0, x10    # two's complement for negative numbers (if a3 = 1)
    
end:
    nop