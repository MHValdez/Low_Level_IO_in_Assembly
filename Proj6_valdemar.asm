TITLE Low-level I/O Integer Analyzer    (Proj6_valdemar.asm)

; Author: Marcos Valdez
; Last Modified: 05/28/2022
; OSU email address: valdemar@oregonstate.edu
; Course number/section:   CS271 Section 400
; Project Number: 6               Due Date: 06/06/2022
; Description: A modularized program that gets 10 32 bit, signed
; integers from the user and displays the integers, their sum, and
; their truncated average by reading and writing all numbers as strings
; and using ONLY low-level I/O commands for string/integer conversion.
; The main procedure first calls procedure message, to write an intro
; and program explanation to the console. main then repeatedly calls
; procedure ReadVal and stores returns in an array, in a loop,
; until ReadVal has returned 10 valid inputs. Main then repeatedly
; calls procedures message and WriteVal, in a loop, until all outputs
; have been displayed. main finally calls procedure message to write
; an outro. The procedure message is a generalized procedure for writing
; text to the console. ReadVal invokes macro mGetString, which prompts 
; the user to enter a value and stores the input as a string. Then,
; ReadVal uses low-level I/O commands to validate the sting represents
; a 32 bit, signed integer. If not, it reprompts the user. If so, it
; returns the converted integers value to main. WriteVal calls message
; to provide desciptors of output numbers. WriteVal uses low-level I/O
; commands to convert each stored integer back to string and invokes
; macro mDisplayString, which prints the string.


INCLUDE Irvine32.inc

; (insert macro definitions here)

; (insert constant definitions here)

.data

; (insert variable definitions here)

.code
main PROC

; (insert executable instructions here)

	Invoke ExitProcess,0	; exit to operating system
main ENDP

; --------------------------------------------------------------------------------- 
; Name: message 
;  
; Writes a string to the console for informational purposes.
; 
; Preconditions: Address of someString is on the stack
; 
; Postconditions: string at someString displayed on console
; 
; Receives:
;	someString	=	reference to memory location of a string
; 
; Returns:
;	None
;
; ---------------------------------------------------------------------------------
message PROC
	PUSH	EBP
	MOV		EBP,	ESP



	POP		EBP
	RET		
message ENDP

; --------------------------------------------------------------------------------- 
; Name: ReadVal 
;  
; Invokes macro mGetString to prompt the user to enter a signed integer.
; Reads the input as a string and uses low-level I/O commands to validate
; the input as a 32 bit, signed integer. Reprompts until input is valid
; and stores value.
; 
; Preconditions: Addresses of someString and validInt are on the stack
; 
; Postconditions: prompt(s) at someString displayed on console and
;				  validInt contains a validated value
; 
; Receives:
;	someString	=	reference to memory location of a prompt string
;	validInt	=	reference to memoroy location of an SDWORD
; 
; Returns:
;	validInt	=	32 bit, signed integer entered by user
;
; ---------------------------------------------------------------------------------
ReadVal PROC
	PUSH	EBP
	MOV		EBP,	ESP



	POP		EBP
	RET		
ReadVal ENDP

; --------------------------------------------------------------------------------- 
; Name: WriteVal 
;  
; Uses low-level I/O commands to convert a 32 bit, signed integer to a string.
; Displays a descriptive message on the console and invokes macro mDisplayString
; to display string representing the converted integer.
;
; Preconditions: Address of someString and someInt are on the stack
; 
; Postconditions: desciptive message at someString and string representation
;				  of someInt displayed on console
; 
; Receives:
;	someString	=	reference to memory location of a descriptive string
;	someInt		=	a 32 bit, signed integer value
; 
; Returns:
;	None
;
; ---------------------------------------------------------------------------------
WriteVal PROC
	PUSH	EBP
	MOV		EBP,	ESP



	POP		EBP
	RET		
WriteVal ENDP

END main
