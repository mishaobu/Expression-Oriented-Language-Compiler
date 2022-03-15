.globl patina_expr
.type patina_expr, @function

patina_expr:
pushq %rbp
movq %rsp, %rbp
movq $1, %rax
pushq %rax
movq $1, %rax
pushq %rax
movq $3, %rax
pushq %rax
WHILE_START_L0:
movq $0, %rax
pushq %rax
movq -24(%rbp), %rax
popq %rsi
cmpq %rsi, %rax
movq $0, %rax
movq $1, %rsi
cmovge %rsi, %rax
cmpq $0, %rax
je EXIT_WHILE_L0
movq -16(%rbp), %rax
pushq %rax
movq -8(%rbp), %rax
popq %rsi
addq %rsi, %rax
pushq %rax
movq $1, %rax
pushq %rax
movq -24(%rbp), %rax
popq %rsi
subq %rsi, %rax
movq %rax, -24(%rbp)
movq -16(%rbp), %rax
movq %rax, -8(%rbp)
movq -32(%rbp), %rax
movq %rax, -16(%rbp)
popq %rcx
jmp WHILE_START_L0
EXIT_WHILE_L0:
movq -16(%rbp), %rax
popq %rcx
popq %rcx
popq %rcx
popq %rbp
ret
