	.file	"matrix_sequential.c"
	.text
	.p2align 4
	.def	elapsed_seconds;	.scl	3;	.type	32;	.endef
	.seh_proc	elapsed_seconds
elapsed_seconds:
	subq	$56, %rsp
	.seh_stackalloc	56
	.seh_endprologue
	leaq	40(%rsp), %rcx
	call	*__imp_QueryPerformanceCounter(%rip)
	testl	%eax, %eax
	je	.L4
	pxor	%xmm0, %xmm0
	pxor	%xmm1, %xmm1
	cvtsi2sdq	40(%rsp), %xmm0
	cvtsi2sdq	timer_frequency(%rip), %xmm1
	divsd	%xmm1, %xmm0
	addq	$56, %rsp
	ret
.L4:
	movl	$1, %ecx
	call	exit
	nop
	.seh_endproc
	.section .rdata,"dr"
.LC0:
	.ascii "Memory allocation failed\0"
	.text
	.p2align 4
	.globl	create_matrix
	.def	create_matrix;	.scl	2;	.type	32;	.endef
	.seh_proc	create_matrix
create_matrix:
	subq	$40, %rsp
	.seh_stackalloc	40
	.seh_endprologue
	movslq	%ecx, %rcx
	imulq	%rcx, %rcx
	salq	$2, %rcx
	call	malloc
	testq	%rax, %rax
	je	.L7
	addq	$40, %rsp
	ret
.L7:
	leaq	.LC0(%rip), %rcx
	call	perror
	movl	$1, %ecx
	call	exit
	nop
	.seh_endproc
	.p2align 4
	.globl	free_matrix
	.def	free_matrix;	.scl	2;	.type	32;	.endef
	.seh_proc	free_matrix
free_matrix:
	.seh_endprologue
	jmp	free
	.seh_endproc
	.section .rdata,"dr"
.LC1:
	.ascii "r\0"
.LC2:
	.ascii "Error opening matrix file\0"
.LC3:
	.ascii "%d\0"
.LC4:
	.ascii "Error reading matrix values\12\0"
.LC5:
	.ascii "Invalid CSV format\12\0"
	.text
	.p2align 4
	.globl	load_matrix
	.def	load_matrix;	.scl	2;	.type	32;	.endef
	.seh_proc	load_matrix
load_matrix:
	pushq	%r15
	.seh_pushreg	%r15
	pushq	%r14
	.seh_pushreg	%r14
	pushq	%r13
	.seh_pushreg	%r13
	pushq	%r12
	.seh_pushreg	%r12
	pushq	%rbp
	.seh_pushreg	%rbp
	pushq	%rdi
	.seh_pushreg	%rdi
	pushq	%rsi
	.seh_pushreg	%rsi
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$56, %rsp
	.seh_stackalloc	56
	.seh_endprologue
	movq	%rdx, %r14
	leaq	.LC1(%rip), %rdx
	movl	%r8d, %edi
	call	fopen
	movq	%rax, %rsi
	testq	%rax, %rax
	je	.L10
	testl	%edi, %edi
	jle	.L11
	movl	%edi, %eax
	xorl	%r12d, %r12d
	leal	-1(%rdi), %ebp
	xorl	%r13d, %r13d
	movq	%rax, 40(%rsp)
	.p2align 4
	.p2align 3
.L12:
	leaq	(%r14,%r12,4), %rbx
	xorl	%r15d, %r15d
	jmp	.L15
	.p2align 4,,10
	.p2align 3
.L14:
	leal	1(%r15), %eax
	addq	$4, %rbx
	cmpl	%eax, %edi
	je	.L21
	movl	%eax, %r15d
.L15:
	movq	%rbx, %r8
	leaq	.LC3(%rip), %rdx
	movq	%rsi, %rcx
	call	fscanf
	cmpl	$1, %eax
	jne	.L22
	cmpl	%r15d, %ebp
	jle	.L14
	movq	%rsi, %rcx
	call	fgetc
	cmpl	$44, %eax
	je	.L14
	movl	$2, %ecx
	call	*__imp___acrt_iob_func(%rip)
	movl	$19, %r8d
	movl	$1, %edx
	leaq	.LC5(%rip), %rcx
	movq	%rax, %r9
.L20:
	call	fwrite
	movq	%rsi, %rcx
	call	fclose
	movl	$1, %ecx
	call	exit
	.p2align 4,,10
	.p2align 3
.L21:
	addq	40(%rsp), %r12
	cmpl	%r15d, %r13d
	je	.L11
	addl	$1, %r13d
	jmp	.L12
.L11:
	movq	%rsi, %rcx
	addq	$56, %rsp
	popq	%rbx
	popq	%rsi
	popq	%rdi
	popq	%rbp
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	jmp	fclose
.L22:
	movl	$2, %ecx
	call	*__imp___acrt_iob_func(%rip)
	movl	$28, %r8d
	movl	$1, %edx
	leaq	.LC4(%rip), %rcx
	movq	%rax, %r9
	jmp	.L20
.L10:
	leaq	.LC2(%rip), %rcx
	call	perror
	movl	$1, %ecx
	call	exit
	nop
	.seh_endproc
	.section .rdata,"dr"
.LC6:
	.ascii "w\0"
.LC7:
	.ascii "Error creating result file\0"
	.text
	.p2align 4
	.globl	save_matrix
	.def	save_matrix;	.scl	2;	.type	32;	.endef
	.seh_proc	save_matrix
save_matrix:
	pushq	%r15
	.seh_pushreg	%r15
	pushq	%r14
	.seh_pushreg	%r14
	pushq	%r13
	.seh_pushreg	%r13
	pushq	%r12
	.seh_pushreg	%r12
	pushq	%rbp
	.seh_pushreg	%rbp
	pushq	%rdi
	.seh_pushreg	%rdi
	pushq	%rsi
	.seh_pushreg	%rsi
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$40, %rsp
	.seh_stackalloc	40
	.seh_endprologue
	movq	%rdx, %rdi
	leaq	.LC6(%rip), %rdx
	movl	%r8d, %r13d
	call	fopen
	movq	%rax, %rsi
	testq	%rax, %rax
	je	.L24
	testl	%r13d, %r13d
	jle	.L25
	movl	%r13d, %ebp
	leal	-1(%r13), %r12d
	xorl	%r15d, %r15d
	leaq	0(,%rbp,4), %r14
	.p2align 4
	.p2align 3
.L26:
	xorl	%ebx, %ebx
	.p2align 4
	.p2align 3
.L28:
	movl	(%rdi,%rbx,4), %r8d
	leaq	.LC3(%rip), %rdx
	movq	%rsi, %rcx
	call	fprintf
	cmpl	%ebx, %r12d
	jle	.L27
	movq	%rsi, %rdx
	movl	$44, %ecx
	call	fputc
.L27:
	addq	$1, %rbx
	cmpq	%rbx, %rbp
	jne	.L28
	movq	%rsi, %rdx
	movl	$10, %ecx
	addl	$1, %r15d
	addq	%r14, %rdi
	call	fputc
	cmpl	%r15d, %r13d
	jne	.L26
.L25:
	movq	%rsi, %rcx
	addq	$40, %rsp
	popq	%rbx
	popq	%rsi
	popq	%rdi
	popq	%rbp
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	jmp	fclose
.L24:
	leaq	.LC7(%rip), %rcx
	call	perror
	movl	$1, %ecx
	call	exit
	nop
	.seh_endproc
	.section .rdata,"dr"
.LC8:
	.ascii "\0"
.LC9:
	.ascii "Usage: %s <size>%s\12\0"
	.align 8
.LC10:
	.ascii "Expected a positive integer: %s\12\0"
.LC11:
	.ascii "experiments/matrix/A_%d.csv\0"
.LC12:
	.ascii "experiments/matrix/B_%d.csv\0"
	.align 8
.LC13:
	.ascii "Size exceeds safe integer or allocation limits\12\0"
	.align 8
.LC14:
	.ascii "Input values must be in [0,10]\12\0"
	.align 8
.LC15:
	.ascii "High-resolution timer unavailable\12\0"
.LC16:
	.ascii "sequential\0"
	.align 8
.LC17:
	.ascii "RESULT,%s,%d,%d,%d,%d,%.9f,%llu\12\0"
.LC18:
	.ascii "results/sequential_%d.csv\0"
	.text
	.p2align 4
	.def	benchmark.constprop.0;	.scl	3;	.type	32;	.endef
	.seh_proc	benchmark.constprop.0
benchmark.constprop.0:
	pushq	%r15
	.seh_pushreg	%r15
	pushq	%r14
	.seh_pushreg	%r14
	pushq	%r13
	.seh_pushreg	%r13
	pushq	%r12
	.seh_pushreg	%r12
	pushq	%rbp
	.seh_pushreg	%rbp
	pushq	%rdi
	.seh_pushreg	%rdi
	pushq	%rsi
	.seh_pushreg	%rsi
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$360, %rsp
	.seh_stackalloc	360
	movups	%xmm6, 336(%rsp)
	.seh_savexmm	%xmm6, 336
	.seh_endprologue
	cmpl	$2, %ecx
	je	.L31
	movq	(%rdx), %rbx
	movl	$2, %ecx
	call	*__imp___acrt_iob_func(%rip)
	leaq	.LC8(%rip), %r9
	leaq	.LC9(%rip), %rdx
	movq	%rbx, %r8
	movq	%rax, %rcx
	call	fprintf
.L37:
	movl	$1, %edi
.L30:
	movups	336(%rsp), %xmm6
	movl	%edi, %eax
	addq	$360, %rsp
	popq	%rbx
	popq	%rsi
	popq	%rdi
	popq	%rbp
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	ret
.L31:
	movq	8(%rdx), %rsi
	movq	__imp__errno(%rip), %rdi
	call	*%rdi
	xorl	%edx, %edx
	movl	$10, %r8d
	movl	%edx, (%rax)
	movq	%rsi, %rcx
	leaq	80(%rsp), %rdx
	call	strtol
	movl	%eax, %ebx
	call	*%rdi
	movl	(%rax), %edi
	testl	%edi, %edi
	jne	.L33
	cmpb	$0, (%rsi)
	je	.L33
	movq	80(%rsp), %rax
	cmpb	$0, (%rax)
	jne	.L33
	testl	%ebx, %ebx
	jle	.L33
	cmpl	$21474836, %ebx
	jg	.L54
	xorl	%ecx, %ecx
	movl	%ebx, %esi
	xorl	%r14d, %r14d
	call	omp_set_dynamic
	movl	$1, %ecx
	call	omp_set_num_threads
	movl	%ebx, %ecx
	call	create_matrix
	movl	%ebx, %ecx
	movq	%rax, %r12
	call	create_matrix
	movl	%ebx, %ecx
	movq	%rax, %rbp
	call	create_matrix
	movl	%ebx, %r9d
	movl	$256, %edx
	leaq	.LC11(%rip), %r8
	leaq	80(%rsp), %rcx
	movq	%rax, %r13
	call	snprintf
	movl	%ebx, %r8d
	movq	%r12, %rdx
	leaq	80(%rsp), %rcx
	call	load_matrix
	movl	%ebx, %r9d
	movl	$256, %edx
	leaq	.LC12(%rip), %r8
	leaq	80(%rsp), %rcx
	call	snprintf
	movl	%ebx, %r8d
	movq	%rbp, %rdx
	leaq	80(%rsp), %rcx
	call	load_matrix
	movq	%rsi, %rax
	imulq	%rsi, %rax
.L36:
	cmpl	$10, (%r12,%r14,4)
	ja	.L38
	cmpl	$10, 0(%rbp,%r14,4)
	ja	.L38
	addq	$1, %r14
	cmpq	%rax, %r14
	jne	.L36
	leaq	timer_frequency(%rip), %rcx
	call	*__imp_QueryPerformanceFrequency(%rip)
	testl	%eax, %eax
	je	.L55
	movl	%edi, 76(%rsp)
	salq	$2, %rsi
	leaq	0(%r13,%r14,4), %r14
	movl	$-2, 72(%rsp)
.L48:
	call	elapsed_seconds
	movq	%r12, %r15
	movq	%r13, %rcx
	xorl	%edi, %edi
	movapd	%xmm0, %xmm6
	.p2align 4
	.p2align 3
.L41:
	movq	%rsi, %r8
	xorl	%edx, %edx
	call	memset
	movq	%rbp, %r9
	xorl	%r10d, %r10d
	movq	%rax, %rcx
	.p2align 4
	.p2align 3
.L43:
	movl	(%r15,%r10,4), %r8d
	xorl	%eax, %eax
	.p2align 5
	.p2align 4
	.p2align 3
.L42:
	movl	(%r9,%rax,4), %edx
	imull	%r8d, %edx
	addl	%edx, (%rcx,%rax,4)
	addq	$1, %rax
	cmpl	%eax, %ebx
	jg	.L42
	addq	$1, %r10
	addq	%rsi, %r9
	cmpl	%r10d, %ebx
	jg	.L43
	addl	$1, %edi
	addq	%rsi, %rcx
	addq	%rsi, %r15
	cmpl	%edi, %ebx
	jg	.L41
	call	elapsed_seconds
	movq	%r13, %rax
	xorl	%edx, %edx
	.p2align 4
	.p2align 4
	.p2align 3
.L45:
	movslq	(%rax), %rcx
	addq	$4, %rax
	addq	%rcx, %rdx
	cmpq	%rax, %r14
	jne	.L45
	movl	72(%rsp), %eax
	leal	1(%rax), %r15d
	testl	%eax, %eax
	js	.L46
	subsd	%xmm6, %xmm0
	movq	%rdx, 56(%rsp)
	movl	$1, %r9d
	movl	%ebx, %r8d
	movl	%r15d, 40(%rsp)
	leaq	.LC16(%rip), %rdx
	leaq	.LC17(%rip), %rcx
	movl	$1, 32(%rsp)
	movsd	%xmm0, 48(%rsp)
	call	printf
	cmpl	$5, %r15d
	je	.L47
.L46:
	movl	%r15d, 72(%rsp)
	jmp	.L48
.L38:
	movl	$2, %ecx
	call	*__imp___acrt_iob_func(%rip)
	movl	$31, %r8d
	movl	$1, %edx
	leaq	.LC14(%rip), %rcx
	movq	%rax, %r9
	call	fwrite
	movq	%r12, %rcx
	call	free
	movq	%rbp, %rcx
	call	free
	movq	%r13, %rcx
	call	free
	jmp	.L37
.L54:
	movl	$2, %ecx
	call	*__imp___acrt_iob_func(%rip)
	movl	$47, %r8d
	movl	$1, %edx
	leaq	.LC13(%rip), %rcx
	movq	%rax, %r9
	call	fwrite
	jmp	.L37
.L47:
	movl	%ebx, %r9d
	leaq	80(%rsp), %rcx
	leaq	.LC18(%rip), %r8
	movl	$256, %edx
	movl	76(%rsp), %edi
	call	snprintf
	movl	%ebx, %r8d
	movq	%r13, %rdx
	leaq	80(%rsp), %rcx
	call	save_matrix
	movq	%r12, %rcx
	call	free
	movq	%rbp, %rcx
	call	free
	movq	%r13, %rcx
	call	free
	jmp	.L30
.L55:
	movl	$2, %ecx
	call	*__imp___acrt_iob_func(%rip)
	movl	$34, %r8d
	movl	$1, %edx
	leaq	.LC15(%rip), %rcx
	movq	%rax, %r9
	call	fwrite
	movl	$1, %ecx
	call	exit
.L33:
	movl	$2, %ecx
	call	*__imp___acrt_iob_func(%rip)
	movq	%rsi, %r8
	leaq	.LC10(%rip), %rdx
	movq	%rax, %rcx
	call	fprintf
	movl	$1, %ecx
	call	exit
	nop
	.seh_endproc
	.section	.text.startup,"x"
	.p2align 4
	.globl	main
	.def	main;	.scl	2;	.type	32;	.endef
	.seh_proc	main
main:
	subq	$56, %rsp
	.seh_stackalloc	56
	.seh_endprologue
	movl	%ecx, 44(%rsp)
	movq	%rdx, 32(%rsp)
	call	__main
	movq	32(%rsp), %rdx
	movl	44(%rsp), %ecx
	addq	$56, %rsp
	jmp	benchmark.constprop.0
	.seh_endproc
.lcomm timer_frequency,8,8
	.def	__main;	.scl	2;	.type	32;	.endef
	.ident	"GCC: (Rev6, Built by MSYS2 project) 16.2.0"
	.def	exit;	.scl	2;	.type	32;	.endef
	.def	malloc;	.scl	2;	.type	32;	.endef
	.def	perror;	.scl	2;	.type	32;	.endef
	.def	free;	.scl	2;	.type	32;	.endef
	.def	fopen;	.scl	2;	.type	32;	.endef
	.def	fscanf;	.scl	2;	.type	32;	.endef
	.def	fgetc;	.scl	2;	.type	32;	.endef
	.def	fwrite;	.scl	2;	.type	32;	.endef
	.def	fclose;	.scl	2;	.type	32;	.endef
	.def	fprintf;	.scl	2;	.type	32;	.endef
	.def	fputc;	.scl	2;	.type	32;	.endef
	.def	strtol;	.scl	2;	.type	32;	.endef
	.def	omp_set_dynamic;	.scl	2;	.type	32;	.endef
	.def	omp_set_num_threads;	.scl	2;	.type	32;	.endef
	.def	snprintf;	.scl	2;	.type	32;	.endef
	.def	memset;	.scl	2;	.type	32;	.endef
	.def	printf;	.scl	2;	.type	32;	.endef
