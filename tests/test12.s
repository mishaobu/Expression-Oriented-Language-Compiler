.globl patina_expr
.type patina_expr, @function

patina_expr:
pushq %rbp
movq %rsp, %rbp
movq $1, %rax
pushq %rax
movq -8(%rbp), %rax
pushq %rax
movq -16(%rbp), %rax
pushq %rax
movq -16(%rbp), %rax
popq %rsi
addq %rsi, %rax
pushq %rax
movq -16(%rbp), %rax
pushq %rax
movq -24(%rbp), %rax
popq %rsi
addq %rsi, %rax
pushq %rax
movq -32(%rbp), %rax
pushq %rax
movq -16(%rbp), %rax
pushq %rax
movq -24(%rbp), %rax
popq %rsi
addq %rsi, %rax
popq %rsi
addq %rsi, %rax
popq %rcx
popq %rcx
popq %rcx
pushq %rax
movq $2, %rax
pushq %rax
movq $3, %rax
pushq %rax
movq -32(%rbp), %rax
pushq %rax
movq -32(%rbp), %rax
popq %rsi
addq %rsi, %rax
popq %rcx
popq %rcx
popq %rsi
addq %rsi, %rax
popq %rcx
popq %rbp
ret
