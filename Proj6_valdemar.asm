TITLE Low-level I/O Integer Analyzer    (Proj6_valdemar.asm)

; Author: Marcos Valdez
; Last Modified: 06/04/2022
; OSU email address: valdemar@oregonstate.edu
; Course number/section:   CS271 Section 400
; Project Number: 6               Due Date: 06/06/2022
; Description: A modularized program that gets 10 32 bit, signed
; integers from the user and displays the integers, their sum, and
; their truncated average by reading and writing all numbers as strings
; and using ONLY low-level I/O commands for string/integer conversion.
; The main procedure first calls procedure message, to write an intro
; and program explanation to the console. main then repeatedly calls
; procedure ReadVal, in a loop, and stores returns in an array
; until ReadVal has returned 10 valid inputs. Main then repeatedly
; calls procedures message and WriteVal, in a loop, until all entries
; have been displayed. main calls procedure calculate to get the sum and
; truncated average followed by message and ReadVal twice to display them.
; main finally calls procedure message to write an outro. The procedure
; message is a generalized procedure for writing text to the console. It
; invokes macro mDisplayString. ReadVal invokes macro mGetString, which
; prompts the user to enter a value and stores the input as a string.
; Then, ReadVal uses low-level I/O commands to validate the sting
; represents a 32 bit, signed integer. If not, it reprompts the user.
; If so, it returns the converted integers value to main. WriteVal uses
; low-level I/O commands to convert each stored integer back to string
; and invokes macro mDisplayString, which prints the string. Procedure
; calculate is a simple integer calculator.

INCLUDE Irvine32.inc

; --------------------------------------------------------------------------------- 
; Name: mGetString
; 
; Displays a prompt and gets a string input from the user of length MAX + 2
; 
; Preconditions: valid arguments passed; arguments are not EAX, EBX, ECX, or EDX
; 
; Receives: 
;	output	=	reference to memory location of a prompt string
;	input	=	reference to memory location of a BYTE array of length MAX + 3
;	size	=	reference to memory location of a DWORD to store input length
; 
; Returns:
;	input	=	a user input string of maximum length MAX + 2 excluding null terminator
;	size	=	the actual length of input excluding null terminator
;
; --------------------------------------------------------------------------------- 
mGetString MACRO output:REQ, input:REQ, size:REQ
	PUSH	EAX
	PUSH	EBX
	PUSH	ECX
	PUSH	EDX
	
	mDisplayString	output						; dipslay prompt

	MOV		ECX,	MAX + 2						; get and record user input
	MOV		EDX,	input
	CALL	ReadString

	MOV		EBX,	size						; record input length
	MOV		[EBX],	EAX

	POP		EDX
	POP		ECX
	POP		EBX
	POP		EAX
ENDM

; --------------------------------------------------------------------------------- 
; Name: mDisplayString
; 
; Displays a string
; 
; Preconditions: valid argument passed; argument is not EDX
; 
; Receives: 
;	output	=	reference to memory location of a string
; 
; Returns:
;	None
;
; --------------------------------------------------------------------------------- 
mDisplayString MACRO output:REQ
	PUSH	EDX

	MOV		EDX,	output						; display string
	CALL	WriteString

	POP		EDX
ENDM

MAX		= 11	; maximum allowable length of input string
NUMS	= 10	; number of integers to get from user

.data

; messages to display
intro			BYTE	"Low-level I/O Integer Analyzer by Marcos Valdez",13,10,13,10,0
instruct		BYTE	"Please provide 10 decimal integers between -(2^31) and 2^31 - 1.",13,10,
						"After 10 valid entries have been made, the integers will be",13,10,
						"displayed along with thier sum and their truncated average.",13,10,13,10,0

prompt			BYTE	"Please enter an signed integer: ",0
error			BYTE	"ERROR: Number entered is too large, entry is not a number, or no entry was made.",13,10,0
retry			BYTE	"Please try again: ",0

return			BYTE	13,10,0

info1			BYTE	"You entered the following integers:",13,10,0
comma			BYTE	", ",0
info2			BYTE	"The sum of these integers is: ",0
info3			BYTE	"Thier truncated average is: ",0

outro			BYTE	"Thank you for using this program. Goodbye!",13,10,13,10,0

; user input storage, tracking, and manipulation
intString		BYTE	MAX + 3 DUP(?)				; for both user input and output to console
revString		BYTE	MAX + 3 DUP(?)				; intermediary storage for int-to-string conversion

intStrType		DWORD	TYPE intString
intStrLength	DWORD	?

integers		SDWORD	NUMS DUP(?)
intType			DWORD	TYPE integers

; calculated values
sum				SDWORD	?
avg				SDWORD	?


.code
main PROC
	PUSH	ECX
	PUSH	ESI
	PUSH	EDI

; -------------------------- 
; Displays program introduction and explaination
; -------------------------- 
	PUSH	OFFSET intro
	CALL	message
	
	PUSH	OFFSET instruct
	CALL	message

; -------------------------- 
; Gets 10 32 bit, signed integers from the user
; -------------------------- 
	MOV		ECX,	NUMS
	MOV		EDI,	OFFSET integers

_getInts:
	PUSH	OFFSET prompt
	PUSH	OFFSET error
	PUSH	OFFSET retry
	PUSH	OFFSET intString
	PUSH	OFFSET intStrLength
	PUSH	EDI
	CALL	ReadVal
	ADD		EDI,	intType
	LOOP	_getInts

	PUSH	OFFSET return
	CALL	message

; -------------------------- 
; Displays valid integers entered by the user
; -------------------------- 
	MOV		ESI,	OFFSET integers

	PUSH	OFFSET info1						; description and first integer
	CALL	message
	PUSH	OFFSET intString
	PUSH	OFFSET revString
	PUSH	[ESI]
	CALL	WriteVal
	
	ADD		ESI,	intType						; last 9 integers with formatting
	MOV		ECX,	NUMS - 1

_showInts:
	PUSH	OFFSET comma
	CALL	message
	PUSH	OFFSET intString
	PUSH	OFFSET revString
	PUSH	[ESI]
	CALL	WriteVal
	ADD		ESI,	intType
	LOOP	_showInts

	PUSH	OFFSET return
	CALL	message

; -------------------------- 
; Calculates an  displays sum and truncated average
; -------------------------- 
	PUSH	OFFSET sum
	PUSH	OFFSET avg
	PUSH	OFFSET integers
	PUSH	intType
	CALL	calculate

	PUSH	OFFSET info2						; description and sum
	CALL	message

	PUSH	OFFSET intString
	PUSH	OFFSET revString
	PUSH	sum
	CALL	WriteVal
	
	PUSH	OFFSET return
	CALL	message

	PUSH	OFFSET info3						; description and truncated average
	CALL	message

	PUSH	OFFSET intString
	PUSH	OFFSET revString
	PUSH	avg
	CALL	WriteVal

	PUSH	OFFSET return
	CALL	message
	PUSH	OFFSET return
	CALL	message

; -------------------------- 
; Displays farewell message
; -------------------------- 
	PUSH	OFFSET outro
	CALL	message

	POP		EDI
	POP		ESI
	POP		ECX

	Invoke ExitProcess,0	; exit to operating system
main ENDP

; --------------------------------------------------------------------------------- 
; Name: message 
;  
; Writes a string to the console for informational purposes.
; Uses macro mDisplayString.
; 
; Preconditions: Receives value is on the stack
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

	mDisplayString	[EBP+8]

	POP		EBP
	RET		4
message ENDP

; --------------------------------------------------------------------------------- 
; Name: ReadVal 
;  
; Invokes macro mGetString to prompt the user to enter a signed integer.
; Reads the input as a string and uses low-level I/O commands to validate
; the input as a 32 bit, signed integer. Reprompts until input is valid
; and stores value.
; 
; Preconditions: Receives values are on the stack
; 
; Postconditions: prompt(s) at someString displayed on console and
;				  validInt contains a validated value. inputString
;				  contains the last user input from console and
;				  inputLength contains said input's character count
; 
; Receives:
;	prompt		=	reference to memory location of a prompt string
;	error		=	reference to memory location of an error message string
;	retry		=	reference to memory location of a prompt string
;	inputString =	reference to memory location of a BYTE input buffer
;	inputLength =	reference to memory location of a DWORD to store input length
;	validInt	=	reference to memoroy location of an SDWORD to store an integer
; 
; Returns:
;	validInt	=	32 bit, signed integer entered by user
;
; ---------------------------------------------------------------------------------
ReadVal PROC
	PUSH	EBP
	MOV		EBP,	ESP
	PUSH	EAX
	PUSH	EBX
	PUSH	ECX
	PUSH	EDX
	PUSH	ESI

	mGetString		[EBP+28], [EBP+16], [EBP+12]	; prompt, inputString, inputLength

; -------------------------- 
; Performs validation that input was made
; and characters are valid as well as an
; initial size check based on string length
; -------------------------- 
_validate:
	MOV		ECX,	[EBP+12]						; inputLength
	
	MOV		EAX,	0								; ensure input was made
	CMP		[ECX],	EAX
	JE		_invalid

	MOV		EAX,	MAX								; ensure input is 11 characters or fewer
	CMP		[ECX],	EAX
	JG		_invalid

	MOV		ESI,	[EBP+16]						; inputString
	MOV		EAX,	[EBP+12]						; inputLength
	MOV		ECX,	[EAX]
	SUB		ECX,	1
	CLD

	LODSB

	CMP		AL,		43								; check if first char is +
	JE		_charCheck

	CMP		AL,		45								; check if first char is -
	JE		_charCheck

	CMP		AL,		48								; check if first char is not a number
	JL		_invalid
	CMP		AL,		57
	JG		_invalid

	MOV		ESI,	[EBP+16]						; inputString
	MOV		EAX,	[EBP+12]						; inputLength
	MOV		ECX,	[EAX]
	CLD

_charCheck:
	LODSB

	CMP		AL,		48								; check if char is not a number
	JL		_invalid
	CMP		AL,		57
	JG		_invalid

	LOOP	_charCheck

	JMP		_intConvert								; convert when all chars valid
	
_invalid:
	mDisplayString	[EBP+24]						; error
	mGetString		[EBP+20], [EBP+16], [EBP+12]	; retry, inputString, inputLength

	JMP		_validate

; -------------------------- 
; Converts previsionally valid entries to strings
; Entries which have passed all checks at this point
; may still be larger than 32 bits
; -------------------------- 
_intConvert:
	MOV		ESI,	[EBP+16]						; inputString
	MOV		EAX,	[EBP+12]						; inputLength
	MOV		ECX,	[EAX]
	SUB		ECX,	1
	MOV		EAX,	0
	MOV		EDX,	10
	CLD

	LODSB

	CMP		AL,		43								; check if first char is +
	JE		_add

	CMP		AL,		45								; check if first char is -
	JE		_sub

	MOV		ESI,	[EBP+16]						; inputString
	ADD		ECX,	1

; -------------------------- 
; Convets positive integers
; -------------------------- 
_add:
	MOV		EAX,	0							; initialize converted value

_addLoop:
	PUSH	EAX
	LODSB
	SUB		AL,		48							; perform digit conversion from ASCII to integer
	MOV		EBX,	0
	MOV		BL,		AL
	POP		EAX

	MUL		EDX									; multiply existing value by 10 and add next digit
	JO		_invalid							; making overflow checks after each operation
	ADD		EAX,	EBX
	JO		_invalid
	MOV		EDX,	10

	LOOP	_addLoop

	JMP		_record

; -------------------------- 
; Convets negative integers
; -------------------------- 
_sub:
	MOV		EAX,	0							; initialize converted value

_subLoop:
	PUSH	EAX
	LODSB
	SUB		AL,		48							; perform digit conversion from ASCII to integer
	MOV		EBX,	0
	MOV		BL,		AL
	POP		EAX

	IMUL	EDX									; multiply existing value by 10 and add next digit
	JO		_invalid							; making overflow checks after each operation
	SUB		EAX,	EBX
	JO		_invalid
	MOV		EDX,	10

	LOOP	_subLoop

; -------------------------- 
; Records converted and fully validated integers
; -------------------------- 
_record:
	MOV		EDX,	[EBP+8]
	MOV		[EDX],	EAX

	POP		ESI
	POP		EDX
	POP		ECX
	POP		EBX
	POP		EAX
	POP		EBP
	RET		24
ReadVal ENDP

; --------------------------------------------------------------------------------- 
; Name: WriteVal 
;  
; Uses low-level I/O commands to convert a 32 bit, signed integer to a string.
; Invokes macro mDisplayString to display string.
;
; Preconditions: Receives values are on the stack
; 
; Postconditions: string representation of someInt displayed on console
; 
; Receives:
;	intString	=	reference to memoroy location a string for display
;	revString	=	reference to memoroy location a string for converting the int
;	someInt		=	a 32 bit, signed integer value
; 
; Returns:
;	intString	=	string for display
;	revString	=	reversed string only used for conversion
;
; ---------------------------------------------------------------------------------
WriteVal PROC
	PUSH	EBP
	MOV		EBP,	ESP
	PUSH	EAX
	PUSH	EBX
	PUSH	ECX
	PUSH	EDX
	PUSH	ESI
	PUSH	EDI

	MOV		EDI,	[EBP+12]						; revString
	MOV		EAX,	[EBP+8]							; someInt
	MOV		EBX,	0								; integer is non-negative
	MOV		ECX,	0								; initialize string length
	CLD
	
	CMP		EAX,	0								; record whether integer is negative
	JGE		_strConvert

	MOV		EBX,	1
	NEG		EAX

; -------------------------- 
; Converts integer to a reversed string representation
; -------------------------- 
_strConvert:
	CDQ												; repeatedly divide by 10 and collect
	PUSH	ECX										; digits from remainder
	MOV		ECX,	10
	DIV		ECX
	POP		ECX
	
	PUSH	EAX
	MOV		AL,		DL
	ADD		AL,		48								; perform digit conversion from integer to ASCII
	STOSB
	POP		EAX

	INC		ECX										; count characters

	CMP		EAX,	0
	JG		_strConvert

	CMP		EBX,	0
	JE		_terminate

	MOV		AL,		45								; make negative
	STOSB

	INC		ECX										; count - sign

_terminate:
	MOV		AL,		0								; append null terminator
	STOSB

; -------------------------- 
; Copies reversed string, in reverse,
; to create string for final display
; -------------------------- 
	MOV		ESI,	[EBP+12]						; revString, last element
	ADD		ESI,	ECX
	DEC		ESI
	MOV		EDI,	[EBP+16]						; intString

_reverse:
	STD												; iterate over revString in reverse
	LODSB
	CLD												; iterate over intString forward
	STOSB
	LOOP	_reverse

	MOV		AL,		0								; append null terminator
	STOSB

mDisplayString	[EBP+16]							; intString

	POP		EDI
	POP		ESI
	POP		EDX
	POP		ECX
	POP		EBX
	POP		EAX
	POP		EBP
	RET		12
WriteVal ENDP

; --------------------------------------------------------------------------------- 
; Name: calculate
;  
; Computes the sum and truncated average of the integers in an array.
;
; Preconditions: Receives values are on the stack
; 
; Postconditions: returns only
; 
; Receives:
;	sum			=	reference to memoroy location for calculated sum
;	avg			=	reference to memoroy location for calculated truncated average
;	integers	=	an array of 32 bit, signed integer values
;	intType		=	element size of integers array
; 
; Returns:
;	sum			=	calculated sum
;	avg			=	calculated truncated average
;
; ---------------------------------------------------------------------------------
calculate PROC
	PUSH	EBP
	MOV		EBP,	ESP
	PUSH	EAX
	PUSH	ECX
	PUSH	ESI
	PUSH	EDI

	MOV		ESI,	[EBP+12]							; integers
	MOV		EAX,	0
	MOV		ECX,	NUMS

; -------------------------- 
; Calculates sum
; -------------------------- 
_sum:
	ADD		EAX,	[ESI]
	ADD		ESI,	[EBP+8]								; intType
	LOOP	_sum

	MOV		EDI,	[EBP+20]							; sum
	MOV		[EDI],	EAX

; -------------------------- 
; Calculates truncated average
; Remainder is ignored
; -------------------------- 
	MOV		ECX,	NUMS
	CDQ
	IDIV	ECX

	MOV		EDI,	[EBP+16]							; avg
	MOV		[EDI],	EAX

	POP		EDI
	POP		ESI
	POP		ECX
	POP		EAX
	POP		EBP
	RET		16
calculate ENDP

END main
