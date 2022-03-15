.globl patina_expr
.type patina_expr, @function

patina_expr:
pushq %rbp
movq %rsp, %rbp
movq $4, %rax
pushq %rax
movq $0, %rax
movq -8(%rbp), %rax
pushq %rax
movq -8(%rbp), %rax
popq %rsi
cmpq %rsi, %rax
movq $1, %rax
movq $0, %rsi
cmove %rsi, %rax
cmpq $0, %rax
je IF_FALSE_L0
movq $2, %rax
jmp IF_END_L0
IF_FALSE_L0:
movq $4, %rax
IF_END_L0:
popq %rcx
pushq %rax
movq $0, %rax
movq $2, %rax
pushq %rax
movq $0, %rax
popq %rcx
pushq %rax
movq $1, %rax
pushq %rax
movq -8(%rbp), %rax
popq %rsi
subq %rsi, %rax
movq %rax, -8(%rbp)
movq $0, %rax
popq %rsi
cmpq %rsi, %rax
movq $0, %rax
movq $1, %rsi
cmove %rsi, %rax
cmpq $0, %rax
je IF_FALSE_L1
movq $3, %rax
jmp IF_END_L1
IF_FALSE_L1:
movq $5, %rax
IF_END_L1:
pushq %rax
movq $0, %rax
movq -16(%rbp), %rax
pushq %rax
movq -8(%rbp), %rax
popq %rsi
imulq %rsi, %rax
popq %rcx
popq %rcx
popq %rbp
ret
