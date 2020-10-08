////////////////////////
//                    //
// Project Submission //
//                    //
////////////////////////

// Partner1: Troy 
// Partner2: Lam 

////////////////////////
//                    //
//       main         //
//                    //
////////////////////////

    lda x0, array
    lda x1, arraySize
	ldur x1, [x1, #0]
    bl printList
    
    lda x0, array
    lda x1, arraySize
    ldur x1, [x1, #0]
    bl BlueRecursion

    lda x0, array
    lda x1, arraySize
    ldur x1, [x1, #0]
    bl printList
	stop

////////////////////////
//                    //
//      RedLoop       //
//                    //
////////////////////////
RedLoop:
    // x0: base address of the (sub)list
    // x1: size of the (sub)list

    // INSERT YOUR CODE HERE
	lsr x2, x1, #1		// (array size)/2
	addi x4, xzr, #0	// iterator

loop:	
	cmp x4, x2		//if iterator is equal to half of array size
	b.eq end		//end loop

	lsl x5, x4, #3		//multiply x4 by 8
	add x5, x0, x5		//x5 - address of array[x4]
	ldur x6, [x5, #0]	//x6 = array[x4]

	add x9, x4, x2		//x4 + half of array size
	lsl x10, x9, #3		//multiply x9 by 8

	add x10, x0, x10	//x10 - address of array[x4+(half of array size)]
	ldur x7, [x10, #0]	//x7 = array[x4+(half of array size)]

	cmp x6, x7		
	b.gt swap		//if greater than, swap values
	addi x4, x4, #1		//increment iterator
	b loop

swap:
	stur x6, [x10, #0]	//store x6 into x7's position in array
	stur x7, [x5, #0] 	//store x7 into x6's position in array
	addi x4, x4, #1		//increment iterator
	b loop

end:	
	br lr 
    
////////////////////////
//                    //
//    RedRecursion    //
//                    //
////////////////////////
RedRecursion:
    // x0: base address of the (sub)list
    // x1: size of the (sub)list

    // INSERT YOUR CODE HERE
	subi sp, sp, #40 	// create 5 bytes of memory
	stur fp, [sp, #0] 	//store fp of caller
			  	//to top of current stack
	addi fp, sp, #32 	// move fp to beginning of current stack
	stur lr, [fp,#0] 	//store lr to callerto bottom
			 	// of current stack
	subis xzr, x1, #1  	//if size>1 then perform body of loop
	b.gt redbody	  	// else branch to done to get out 
	b done		 	// of procedure
redbody:
	stur x0, [fp,#-8] 	//store original x0 and x1
	stur x1, [fp,#-16] 	// because we want to know them later
	bl RedLoop 	 	//start redloop function w/ input (a,size)
	lsr x1, x1, #1    	//divide size by 2 and store in x1
	bl RedRecursion 	//start red recursion w/ input(a,s/2)

	lsl x20,x1,#3  		//multiply size/2 by 8 
	add x0,x20,x0  		//get address of a[size/2] by x0 + 8(size/2)
	bl RedRecursion   	//start red recursion again
			   	// w/ input(a[size/2],size/2)
	ldur x0, [fp,#-8]   	//load original value for x0
	ldur x1, [fp,#-16]  	//load original value for x1
done:
	ldur lr,[fp,#0]	 	//restore lr of caller
	ldur fp,[sp,#0]  	//restore fp of caller
	addi sp, sp, #40 	//pop current stack

	br lr 			//get back to caller
    
////////////////////////
//                    //
//      BLueLoop      //
//                    //
////////////////////////
BLueLoop:
    // x0: base address of the (sub)list
    // x1: size of the (sub)list

    // INSERT YOUR CODE HERE
	addi x3,xzr,#0		  //iterator for loop2
    	subi x2, x1, #1           //iterator for swap2
    	lsr x7, x1, #1            //(array size)/2
loop2:
    	cmp x3, x7              //if iterator is equal to size/2
    	b.eq end2               //end loop

	lsl x4, x3, #3          //x4 = 8*iterator
	add x4, x0, x4          //x4 = address of array[x0 + 8*iterator]
    	ldur x5, [x4, #0]       //x5 = array[x0 + 8*iterator]

    	add x9, x3, x2          //x9 = [x0 + 8*iterator] + (-1)
    	lsl x10, x9, #3         //x10 = 8*x9

    	add x10, x0, x10        //x10 = address of array[x3+(array size - 1)]
    	ldur x6, [x10, #0]      //x6 = array[x3+(array size - 1)]

    	cmp x5, x6
    	b.gt swap2              //if greater than, swap values
    	addi x3, x3, #1         //increment iterator
    	subi x2, x2, #2         //decrement iterator for swap
    	b loop2
swap2:
    	stur x5, [x10, #0]    	//store x5 into x6's position in array
    	stur x6, [x4, #0]     	//store x6 into x5's position in array
    	addi x3, x3, #1        	//increment iterator for loop2
    	subi x2, x2, #2       	//decrement iterator for swap2 
    	b loop2
end2:
    	br lr 

////////////////////////
//                    //
//    BLueRecursion   //
//                    //
////////////////////////
BLueRecursion:
    // x0: base address of the (sub)list
    // x1: size of the (sub)list

    // INSERT YOUR CODE HERE
	subi sp, sp, #40 	// create 5 bytes of memory
	stur fp, [sp, #0] 	//store fp of caller
			  	//to top of current stack
	addi fp, sp, #32 	// move fp to beginning of current stack
	stur lr, [fp,#0] 	//store lr to callerto bottom
			 	// of current stack
	subis xzr, x1, #1  	//if size>1 then perform body of loop
	b.gt bluebody	  	// else branch to done to get out 
	b done2		 	// of procedure
bluebody:
	stur x0, [fp,#-8] 	//store original x0 and x1
	stur x1, [fp,#-16] 	// because we want to know them later
	lsr x1,x1,#1 		//Divide size by 2
	bl BlueRecursion 	//call BlueRecursion w/ input(a,size/2)

		
	lsl x20,x1,#3  		//multiply size/2 by 8 
	add x0,x20,x0 		//get address of a[x0+8*(size/2)]
	bl BlueRecursion 	//call BlueRecursion w/ 								// input(x0+8*(size/2),size/2)	
	ldur x0, [fp,#-8] 	//load original values for x0
	ldur x1, [fp,#-16]	// load original values for x1
	bl BlueLoop 		//call BlueLoops w/ inputs(a,size)

	lsr x1,x1,#1 		// divide size by 2
	bl RedRecursion 	//call RedRecursion w/ input(a,size/2)

	
	lsl x20,x1,#3 		//multiply size/2 by 8 
	add x0, x20,x0 		//get address of a[x0+8*(size/2)]
	bl RedRecursion  	//call RedRecursion w/
				//input(x0+8*(size/2),size/2)

	ldur x0, [fp,#-8]   	//load original value for x0
	ldur x1, [fp,#-16] 	//load original value for x1
done2:
	ldur lr,[fp,#0]	 	//restore lr of caller
	ldur fp,[sp,#0]  	//restore fp of caller
	addi sp, sp, #40 	// pop the stack

	br lr 
    
////////////////////////
//                    //
//     printList      //
//                    //
////////////////////////
printList:
    // x0: base address
    // x1: length of the array

	mov x2, xzr
	addi x5, xzr, #32
	addi x6, xzr, #10
printList_loop:
    cmp x2, x1
    b.eq printList_loopEnd
    lsl x3, x2, #3
    add x3, x3, x0
	ldur x4, [x3, #0]
    putint x4
    putchar x5
    addi x2, x2, #1
    b printList_loop
printList_loopEnd:    
    putchar x6
    br lr
