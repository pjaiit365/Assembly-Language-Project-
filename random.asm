section .data
	tryOutput db 'GUESSING GAME',10,13,'Welcome to the Guessing Game!',10, 13,'You have 3 tries to guess the program generated number...',10,13,
	lenTryOutput equ $ -tryOutput
	enterNumberText db 10,13, 'Enter a number: '
	rightText db 'You guessed right! Good job!',10,13,
	lenRightText equ $ -rightText
	wrongText db 'Sorry. Wrong Guess.',10,13,
	lenWrongText equ $ -wrongText
	tryText db 'Try '
	sys_write equ 1
	stdout equ 1
	sys_read equ 0
	stdin equ 0
	generatedNumber dq '8'
	tryNumber db '4',10,13,
	greaterText db 'The number you entered is greater than the program generated number.',10,13,
	lenGreaterText equ $ -greaterText
	lowerText db 'The number you entered is lower than the program generated number.',10,13,
        lenLowerText equ $ -lowerText
	playAgainText db 'Would you like to play again?[Y/N] Type 1 for YES or 2 for NO: '
	lenPlayAgain equ $ -playAgainText
	yes dq '1'
	no dq '2'

section .bss
	enterNumber resb 20
	playInput resb 1
	linebreak resb 1

section .text
	global _start

_start:
	call _startIntro
	call _inputText
	call _playAgain

	call _exit

_startIntro:
	mov rax, sys_write
	mov rdi, stdout
	mov rsi, tryOutput
	mov rdx, lenTryOutput
	syscall
	ret
	
_inputText:
	mov rax, sys_write
	mov rdi, stdout
	mov rsi, enterNumberText
	mov rdx, 18
	syscall

	mov rax, sys_read
	mov rdi, stdin
	mov rsi, enterNumber
	mov rdx, 20
	syscall

	call text_to_num

	mov rax, [enterNumber]
	;sub rax, '0'
	mov rcx, [generatedNumber]
	sub rcx, '0'
	cmp rax, rcx
	je _jumpRight

	jmp _jumpWrong

	ret

text_to_num:
	mov rbx, enterNumber
	mov rax, 0
	l:
		movzx rcx, byte [rbx]
		cmp rcx, 0xa
		je end
		imul rax, 0xa
		mov rdx, rcx
		sub rcx, 0x30
		inc rbx
		add rax, rcx
		jmp l
		end:
			mov [enterNumber], rax
			ret


_exit:
	mov rax, 60
	mov rdi, 0
	syscall

_jumpRight:
	mov rax, sys_write
	mov rdi, stdout
	mov rsi, rightText
	mov rdx, lenRightText
	syscall
	
	jmp _playAgain

_jumpWrong:
	mov rax, sys_write
	mov rdi, stdout
	mov rsi, wrongText
	mov rdx, lenWrongText
	syscall

	mov rax, [enterNumber]
	;sub rax, '0'
	mov rcx, [generatedNumber]
	sub rcx, '0'
	cmp rax, rcx
	jl _lowerInput

	jmp _greaterInput

	ret

_greaterInput:
	mov rax, sys_write
	mov rdi, stdout
	mov rsi, greaterText
	mov rdx, lenGreaterText
	syscall
	
	jmp _inputText
	
_lowerInput:
        mov rax, sys_write
        mov rdi, stdout
        mov rsi, lowerText
        mov rdx, lenLowerText
        syscall
	
	jmp _inputText

_playAgain:
        mov rax, sys_write
        mov rdi, stdout
        mov rsi, playAgainText
        mov rdx, 63
        syscall

	mov rax, sys_read
        mov rdi, stdin
        mov rsi, playInput
        mov rdx, 1
        syscall

	mov byte [tryNumber], '4'

        mov rcx, [playInput]
        sub rcx, '0'
	mov rax, [yes]
	sub rax, '0'
        cmp rcx, rax
        je _start
	mov rbx, [no]
	sub rbx, '0'
        cmp rcx, rbx
        je _exit

	ret
