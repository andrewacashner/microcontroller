/* Merge sort
 * 
 * Sort a series of integers in O(n log n) time
 *
 * Andrew Cashner
 * 2025/12/21
 */
 .global    sort

.data
    .equ    NUM_INPUTS, 12

input:
    .byte   5, 1, 4, 2, 7, 0, 9, 11, 3, 8, 6, 10
tmp:
    .byte   0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

.text
    
/*-----------------------------------------------------------------------------
 * procedure: sort
 *
 *   INPUT:
 *      - R0: Address of array of numbers
 *      - R1: Length of array
 *
 *   REGISTERS
 *      - R0: Unchanged
 *      - R1: Unchanged
 *      - R2, R3: Used for first and second array element to compare
 *
 *   OUTPUT:
 *      - None
 *
 *   POSTCONDITION:
 *      - The array at address given in R0 is now sorted
 *-----------------------------------------------------------------------------*/
sort:
/*
    push    {LR}
    // Array of one element is sorted
    cmp     R1, #1
    beq     sort_end

    // Array of two elements: just swap if necessary
    cmp     R1, #2
    bgt     sort_split

    // Already sorted: done
    cmp     [R0], [R0, #1]
    blt     sort_end

    // Swap two elements
    ldr     R2, [R0]
    ldr     R3, [R0, #1]
    str     R3, [R0]
    str     R2, [R0, #1]
    bl      sort_end

sort_split:
    push    {R0}
    asrs    R1, R1, #1  // R1 /= 2
    bl      sort

    adds    R0, R0, R1
    bl      sort

    mov     R1, R2
    mov     R0, R1

    pop     {R0}
    bl      merge

sort_end:
    pop     {PC}
    blx     LR

*/

/*-----------------------------------------------------------------------------
 * procedure: merge
 * 
 *   INPUT:
 *     - R0: Address of first subsequence
 *     - R1: Address of second subsequence
 *     - R2: Length of subsequence
 *
 *   OUTPUT:
 *     - None: Input parameters are unchanged
 *
 *   REGISTERS:
 *     - R3: Pointer to first sequence
 *     - R4: Pointer to second sequence
 *     - R5: Loop counter
 *     - R6: Pointer to temporary array
 *
 *   POSTCONDITION:
 *     - The list starting at R0, of length 2 * R2, is now sorted.
 *-----------------------------------------------------------------------------*/
merge:
/*
    push    {R0, R1, R2, LR}
    mov     R0, R3
    mov     R1, R4
    asls    R2, R2, #1
    ldr    R5, #0
    ldr    R6, =tmp

merge_loop:
    cmp     R5, R2
    beq     merge_writeback

    cmp     [R3], [R4]
    bgt     merge_right

    // Store left value
    str     R3, [R6]
    adds    R3, R3, #1
    bl      merge_writebackloop

merge_right:
    // Store right value
    str     R4, [R6]
    adds    R4, R4, #1

merge_endloop:
    adds    R6, R6, #1
    adds    R5, R5, #1
    bl      merge_loop

    // Overwrite temporary values back to source location
merge_writeback:
    pop     {R0, R1, PC}
    ldr    R5, #0
    ldr    R6, =tmp

merge_writeback_loop:
    cmp     R5, R2
    beq     merge_return
    str     R6, [R0, R5]
    adds    R5, R5, #1

merge_return:
    blx     LR
*/
.end
