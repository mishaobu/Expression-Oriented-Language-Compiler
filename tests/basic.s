.globl patina_expr
.type patina_expr, @function

patina_expr:
pushq %rbp
movq %rsp, %rbp
movq $1, %rax
pushq %rax
movq $0, %rax
popq %rsi
not %rsi
addq $2, %rsi
not %rax
addq $2, %rax
imulq %rsi, %rax
not %rax
addq $2, %rax
popq %rbp
ret
