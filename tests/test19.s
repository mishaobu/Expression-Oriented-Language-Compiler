.globl patina_expr
.type patina_expr, @function

patina_expr:
pushq %rbp
movq %rsp, %rbp
movq $3, %rax
pushq %rax
movq $0, %rax
movq $1, %rax
pushq %rax
movq $0, %rax
movq $0, %rax
pushq %rax
movq $0, %rax
WHILE_START_L0:
movq $1, %rax
pushq %rax
movq -16(%rbp), %rax
popq %rsi
cmpq %rsi, %rax
movq $1, %rax
movq $0, %rsi
cmovge %rsi, %rax
pushq %rax
movq $0, %rax
pushq %rax
movq -8(%rbp), %rax
popq %rsi
cmpq %rsi, %rax
movq $0, %rax
movq $1, %rsi
cmovg %rsi, %rax
popq %rsi
not %rsi
addq $2, %rsi
not %rax
addq $2, %rax
imulq %rsi, %rax
not %rax
addq $2, %rax
cmpq $0, %rax
je EXIT_WHILE_L0
movq $1, %rax
pushq %rax
movq -16(%rbp), %rax
pushq %rax
movq -8(%rbp), %rax
popq %rsi
subq %rsi, %rax
popq %rsi
subq %rsi, %rax
movq %rax, -8(%rbp)
movq -16(%rbp), %rax
pushq %rax
movq -8(%rbp), %rax
pushq %rax
movq -8(%rbp), %rax
popq %rsi
imulq %rsi, %rax
popq %rsi
subq %rsi, %rax
movq %rax, -16(%rbp)
movq $1, %rax
pushq %rax
movq -24(%rbp), %rax
popq %rsi
addq %rsi, %rax
movq %rax, -24(%rbp)
jmp WHILE_START_L0
EXIT_WHILE_L0:
movq -24(%rbp), %rax
popq %rcx
popq %rcx
popq %rcx
popq %rbp
ret
