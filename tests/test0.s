.globl patina_expr
.type patina_expr, @function

patina_expr:
pushq %rbp
movq %rsp, %rbp
movq $1, %rax
pushq %rax
movq $0, %rax
popq %rsi
subq %rsi, %rax
pushq %rax
movq -8(%rbp), %rax
popq %rcx
pushq %rax
movq $1, %rax
popq %rsi
addq %rsi, %rax
popq %rbp
ret
