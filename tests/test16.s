.globl patina_expr
.type patina_expr, @function

patina_expr:
pushq %rbp
movq %rsp, %rbp
movq $0, %rax
pushq %rax
movq $0, %rax
pushq %rax
WHILE_START_L0:
movq -16(%rbp), %rax
not %rax
addq $2, %rax
cmpq $0, %rax
je EXIT_WHILE_L0
movq $0, %rax
pushq %rax
WHILE_START_L1:
movq -8(%rbp), %rax
pushq %rax
movq -24(%rbp), %rax
popq %rsi
cmpq %rsi, %rax
movq $1, %rax
movq $0, %rsi
cmovge %rsi, %rax
pushq %rax
movq -16(%rbp), %rax
not %rax
addq $2, %rax
popq %rsi
imulq %rsi, %rax
cmpq $0, %rax
je EXIT_WHILE_L1
movq $10, %rax
pushq %rax
movq -8(%rbp), %rax
popq %rsi
cmpq %rsi, %rax
movq $0, %rax
movq $1, %rsi
cmovg %rsi, %rax
pushq %rax
movq -8(%rbp), %rax
pushq %rax
movq -24(%rbp), %rax
pushq %rax
movq -24(%rbp), %rax
popq %rsi
imulq %rsi, %rax
popq %rsi
cmpq %rsi, %rax
movq $0, %rax
movq $1, %rsi
cmove %rsi, %rax
popq %rsi
imulq %rsi, %rax
cmpq $0, %rax
je IF_FALSE_L2
movq $1, %rax
movq %rax, -16(%rbp)
jmp IF_END_L2
IF_FALSE_L2:
movq $0, %rax
movq %rax, -16(%rbp)
IF_END_L2:
movq $1, %rax
pushq %rax
movq -24(%rbp), %rax
popq %rsi
addq %rsi, %rax
movq %rax, -24(%rbp)
jmp WHILE_START_L1
EXIT_WHILE_L1:
movq $1, %rax
pushq %rax
movq -8(%rbp), %rax
popq %rsi
addq %rsi, %rax
movq %rax, -8(%rbp)
popq %rcx
jmp WHILE_START_L0
EXIT_WHILE_L0:
movq $1, %rax
pushq %rax
movq -8(%rbp), %rax
popq %rsi
subq %rsi, %rax
popq %rcx
popq %rcx
popq %rbp
ret
