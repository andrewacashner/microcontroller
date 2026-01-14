/* sort
 * 
 * Sort a linked list using merge sort in O(n log n) time
 *
 * Andrew Cashner
 * 2026/01/07
 */

.global     sort

.data

.text
            
/*-------------------------------------------------------------
 * sort
 *
 * INPUT
 *   R0:    Address of linked list
 *   R1:    Length of list
 *
 * OUTPUT
 *   None
 *
 * POSTCONDITION
 *   The given list is now sorted.
 *
 * REGISTERS
 *   R0 list head address
 *   R1 list tail address
 *   R2 list tail->link
 *-------------------------------------------------------------*/
sort:
            push        {R0, R1, R2, LR}
            ldr         R0, [R0]        // R0 <- list.head
            bl          sort_inner

            mov         R1, R0          // R1 <- head of sorted and merged list
            pop         {R0}
            str         R1, [R0]        // list.head = sorted head = min

sort_find_tail:
            ldr         R2, [R1, #4]
            cmp         R2, #0
            beq         sort_return

            ldr         R1, [R1, #4]
            bl          sort_find_tail

 sort_return:
            str         R1, [R0, #4]    // list.tail = sorted tail = max
            pop         {R1, R2, PC}
            blx         LR

/*-------------------------------------------------------------
 * inner_sort
 *
 * Recursively split list in halves, sort each half, and merge
 * in sort order.
 *
 * INPUT
 *   R0:    Address of linked list head
 *   R1:    Length of list
 *
 * OUTPUT
 *   R0:    Address of head of sorted list
 *
 * POSTCONDITION
 *   The given list is now sorted.
 *-------------------------------------------------------------*/
sort_inner:       
            push        {R2, R3, LR}
            cmp         R1, #2          // return if length < 2
            blt         sort_inner_return

            bl          split
            bl          sort_inner      // sort left half

            push        {R0}
            mov         R0, R2          // R0: param 1 <- right address
            mov         R1, R3          // R1: param 2 <- right length
            bl          sort_inner      // sort right half
        
            mov         R1, R0          // R1: param 2 <- right address
            pop         {R0}            // R0: param 1 <- left length
            bl          merge           // merge(left, right)

sort_inner_return:
            pop         {R2, R3, PC}
            blx         LR

/*-------------------------------------------------------------
 * split
 * 
 * Split a linked list into two halves
 * 
 * INPUT
 *   R0: Address of head node of linked list
 *   R1: Length of list
 *
 * OUTPUT
 *   R0: Address of left list
 *   R1: New length of left list
 *   R2: Address of right list
 *   R3: Length of right list
 *   R4: Zero
 *   R5: Temp
 *
 * POSTCONDITION
 *   The last node in the left list has been given a null
 *   link to mark the end of the list.
 *-------------------------------------------------------------*/
split:
            push        {LR}
            mov         R5, R1
            mov         R2, R0
            mov         R3, R1
            asrs        R1, R1, #1       // R1 = midpoint = length / 2
            subs        R3, R3, #1
find_split: 
            cmp         R3, R1
            beq         split_return
            adds        R2, #8
            subs        R3, R3, #1
            bl          find_split

split_return:
            subs        R4, R4, R4
            str         R4, [R2, #4]     // End left list with NULL link
            adds        R2, R2, #8        // R2 <- Start of right list

            subs        R1, R5, R1       // R1 <- length - midpoint
            
            pop         {PC}
            blx         LR
            
/*-------------------------------------------------------------
 * merge
 * 
 * Merge two linked lists in sort order
 * 
 * INPUT
 *   R0: Address of left list
 *   R1: Address of right list
 *
 * OUTPUT
 *   R0: Address of head of merged list
 *
 * POSTCONDITION
 *   The list is now in sort order.
 *
 * REGISTERS
 *   R0: Address of left list head
 *   R1: Address of right list head
 *   R2: Temp
 *   R3: Address of next node to examine
 *   R4: Left data
 *   R5: Right data
 *   R6: Left address
 *   R7: Right address
 *-------------------------------------------------------------*/
merge:
            push        {R1, R2, R3, R4, R5, R6, R7, LR}

            mov         R6, R0
            ldr         R4, [R0]            // compare left[0].data, right[0].data
            ldr         R5, [R1]
            cmp         R4, R5
           
            ble         merge_compare
            mov         R0, R1              // right[0] > left[0] ? head <- right   

merge_compare:
            mov         R7, R1

merge_compare_loop:
            mov         R2, R6
            ands        R2, R2, R7
            cmp         R2, #0
            beq         merge_return

            ldr         R4, [R6]            // R4 <- left.data
            ldr         R5, [R7]            // R5 <- right.data
            cmp         R4, R5
            bge         merge_left_greater

            ldr         R3, [R6, #4]        // R3 <- left.link
            cmp         R3, #0
            beq         merge_set_left      // if !left.link, set left

            ldr         R4, [R3]            // or if left.link->data > right.data, set left
            cmp         R4, R5
            ble         merge_advance_left

merge_set_left:
            str         R7, [R6, #4]        // left.link = right

merge_advance_left:
            mov         R6, R3
            bl          merge_compare_loop

merge_left_greater:
            ldr         R3, [R7, #4]        // R3 <- right.link
            cmp         R3, #0
            beq         merge_set_right     // if !right.link, set right

            ldr         R5, [R3]            // or if right.link->data > left.data, set right
            cmp         R5, R4
            ble         merge_advance_right

merge_set_right:
            str         R6, [R7, #4] 

merge_advance_right:
            mov         R7, R3
            bl          merge_compare_loop

merge_return:
            pop         {R1, R2, R3, R4, R5, R6, R7, PC}
            blx         LR

.end