/* Linked list
 * Andrew Cashner
 * 2025/12/23
 */

.global		linked_list_create, linked_list_to_array, linked_list_head_data, linked_list_tail_data

.data	

list_head:
		.word 	0
list_tail:
		.word 	0
memory:
		.space	256

.text

/*---------------------------------------------------------------------------
 * function: linked_list
 * 
 * Return a linked list with the contents of the given input array
 * 
 * INPUT
 *   R0: Address of input array
 *   R1: Length of input array
 *
 * OUTPUT
 *   R0: Address of head of linked list
 *
 * REGISTERS
 *   R2: Address of linked list (= address of list.head field)
 *   R3: Address of list.tail field
 *   R4: Start of memory buffer (will be location of first node)
 *   R5: Loop counter
 *   R6: Tail node
 *   R7: Current input value
 *---------------------------------------------------------------------------*/
linked_list_create:
	push	{LR}

	// Create list
	ldr		R2, =list_head 
	ldr     R3, =list_tail
	ldr     R4, =memory		// R4 <- address to place list head
	str     R4, [R2]        // list.head <- location of first node

	// Loop through input and append nodes
	subs    R5, R5, R5      // R5 <- 0: input loop counter			

load_loop:
	cmp		R5, R1
	beq		create_return

	ldr     R7, [R0]    	// R7 <- next input
	str     R7, [R4]        // create new node at address R6, node.data <- input[R3]

	cmp     R5, #0
	beq     append			// if list is empty, start new list; else append to list

append:
    ldr     R6, [R3]
	str     R4, [R6, #4]    // list.tail.link <- new node

attach:
	str     R4, [R3]        // list.tail <- new node
	adds    R5, R5, #1      // ++ loop counter
	adds    R0, R0, #4      // next input address
	adds    R4, R4, #8      // increment R2 address by 2 words for next node memory position
	bl 		load_loop

create_return:
	ldr 	R0, =list_head
	pop		{PC}
	blx		LR

/*---------------------------------------------------------------------------
 * function: linked_list_to_array
 *
 * Copy the elements of a given linked list in order into a given array.
 *
 * INPUT
 *   R0: address of array to write to
 *   R1: address of linked list to copy 
 *
 * OUTPUT
 *   R0: address of array
 *
 * REGISTERS
 *   R2: address of current element in array
 *   R4: current linked list node pointer
 *   R5: current->link
 *   R6: current->data
 *---------------------------------------------------------------------------*/
linked_list_to_array:
	push	{R0, R1, LR}
	subs	R2, R2, R2			// R2 <- array offset
	ldr     R4, [R1]			// R4 <- current linked list node pointer
	ldr     R5, [R4, #4]        // R5 <- current.link

to_array_loop:
	cmp     R5, #0
	beq     to_array_return

	ldr     R6, [R4]			// R6 <- current.data
	str     R6, [R0, R2]

	adds    R2, R2, #4
	ldr     R5, [R4, #4]        // R5 <- current.link
	mov     R4, R5              // R4: current <- current.link
	bl      to_array_loop

to_array_return:
	pop	    {R0, R1, PC}
	blx	    LR

/*---------------------------------------------------------------------------
 * linked_list_head_data
 * 
 * Return the address of the head of the list.
 *
 * INPUT
 *   R0: Address of linked list
 *
 * OUTPUT
 *   R0: Data of list head node
 *---------------------------------------------------------------------------*/
linked_list_head_data:
	ldr     R0, [R0]
	ldr     R0, [R0]
	blx     LR

/*---------------------------------------------------------------------------
 * linked_list_tail_data
 * 
 * Return the address of the tail of the list.
 *
 * INPUT
 *   R0: Address of linked list
 *
 * OUTPUT
 *   R0: Data of list tail node
 *---------------------------------------------------------------------------*/
linked_list_tail_data:
	ldr     R0, [R0, #4]
	ldr     R0, [R0]
	blx     LR

.end

