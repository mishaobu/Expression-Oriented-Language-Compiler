.globl patina_expr
.type patina_expr, @function

patina_expr:
pushq %rbp
movq %rsp, %rbp
movq $1, %rax
pushq %rax
movq -8(%rbp), %rax
pushq %rax                      push l2 -16
movq -16(%rbp), %rax
pushq %rax
movq -16(%rbp), %rax
popq %rsi
addq %rsi, %rax
pushq %rax                      push l1 -24
movq -16(%rbp), %rax
pushq %rax
movq -24(%rbp), %rax
popq %rsi
addq %rsi, %rax
pushq %rax                      push l3 -32
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
pushq %rax                      this is the value of the second sequence
movq $2, %rax
pushq %rax
movq $3, %rax
pushq %rax
movq -24(%rbp), %rax
pushq %rax
movq -24(%rbp), %rax
popq %rsi
addq %rsi, %rax
popq %rcx
popq %rcx
popq %rsi
addq %rsi, %rax
popq %rcx
popq %rbp
ret
