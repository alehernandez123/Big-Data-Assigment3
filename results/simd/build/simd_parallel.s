	.file	"matrix_parallel.c"
	.text
	.section .rdata,"dr"
	.align 8
.LC0:
	.ascii "Expected a positive integer: %s\12\0"
	.text
	.p2align 4
	.def	positive_int;	.scl	3;	.type	32;	.endef
	.seh_proc	positive_int
positive_int:
	pushq	%rdi
	.seh_pushreg	%rdi
	pushq	%rsi
	.seh_pushreg	%rsi
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$48, %rsp
	.seh_stackalloc	48
	.seh_endprologue
	movq	__imp__errno(%rip), %rsi
	movq	%rcx, %rbx
	call	*%rsi
	leaq	40(%rsp), %rdx
	movl	$10, %r8d
	movq	%rbx, %rcx
	movl	$0, (%rax)
	call	strtol
	movl	%eax, %edi
	call	*%rsi
	movl	(%rax), %eax
	testl	%eax, %eax
	jne	.L2
	cmpb	$0, (%rbx)
	je	.L2
	movq	40(%rsp), %rax
	cmpb	$0, (%rax)
	jne	.L2
	testl	%edi, %edi
	jle	.L2
	movl	%edi, %eax
	addq	$48, %rsp
	popq	%rbx
	popq	%rsi
	popq	%rdi
	ret
.L2:
	movl	$2, %ecx
	call	*__imp___acrt_iob_func(%rip)
	movq	%rbx, %r8
	leaq	.LC0(%rip), %rdx
	movq	%rax, %rcx
	call	fprintf
	movl	$1, %ecx
	call	exit
	nop
	.seh_endproc
	.p2align 4
	.def	matrix_multiplication._omp_fn.0;	.scl	3;	.type	32;	.endef
	.seh_proc	matrix_multiplication._omp_fn.0
matrix_multiplication._omp_fn.0:
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
	subq	$72, %rsp
	.seh_stackalloc	72
	.seh_endprologue
	movq	8(%rcx), %rax
	movl	24(%rcx), %ebx
	movq	16(%rcx), %rsi
	movq	%rax, 40(%rsp)
	movq	(%rcx), %rax
	movq	%rcx, %rdi
	movq	%rax, 32(%rsp)
	call	GOMP_single_start
	testb	%al, %al
	je	.L22
	call	omp_get_num_threads
	movl	%eax, 28(%rdi)
.L22:
	call	GOMP_barrier
	call	omp_get_num_threads
	movl	%eax, %edi
	call	omp_get_thread_num
	movl	%eax, %r13d
	movl	%ebx, %eax
	cltd
	idivl	%edi
	cmpl	%edx, %r13d
	leal	1(%rax), %r15d
	cmovge	%eax, %r15d
	movl	$0, %eax
	cmovl	%eax, %edx
	imull	%r15d, %r13d
	addl	%edx, %r13d
	addl	%r13d, %r15d
	cmpl	%r15d, %r13d
	jge	.L5
	movslq	%ebx, %r9
	movslq	%r13d, %rax
	leaq	0(,%r9,4), %rbp
	movq	%r9, %r14
	leaq	1(%rax), %rdi
	imulq	%rax, %r14
	imulq	%rbp, %rax
	imulq	%rbp, %rdi
	addq	32(%rsp), %rdi
	leaq	(%rsi,%rax), %rcx
.L10:
	testl	%ebx, %ebx
	jg	.L9
	addl	$1, %r13d
	addq	%rbp, %rdi
	addq	%r9, %r14
	addq	%rbp, %rcx
	cmpl	%r13d, %r15d
	jne	.L10
.L5:
	addq	$72, %rsp
	popq	%rbx
	popq	%rsi
	popq	%rdi
	popq	%rbp
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	ret
.L9:
	leal	-1(%rbx), %eax
	movl	%ebx, %esi
	movl	%r15d, 60(%rsp)
	movq	%r9, %r15
	movq	%rax, %r12
	leaq	4(,%rax,4), %rax
	andl	$-4, %esi
	movq	%rax, 48(%rsp)
	movl	%ebx, %eax
	shrl	$2, %eax
	movl	%eax, 56(%rsp)
	.p2align 4
	.p2align 3
.L16:
	movq	48(%rsp), %r8
	xorl	%edx, %edx
	call	memset
	movl	56(%rsp), %r8d
	movq	40(%rsp), %rdx
	movq	%rax, %rcx
	movq	32(%rsp), %rax
	salq	$4, %r8
	leaq	(%rax,%r14,4), %r11
	.p2align 4
	.p2align 3
.L15:
	movl	(%r11), %r9d
	cmpl	$2, %r12d
	jbe	.L23
.L14:
	movd	%r9d, %xmm4
	xorl	%eax, %eax
	pshufd	$0, %xmm4, %xmm2
	movdqa	%xmm2, %xmm3
	psrlq	$32, %xmm3
	.p2align 6
	.p2align 4
	.p2align 3
.L12:
	movdqu	(%rdx,%rax), %xmm0
	movdqa	%xmm0, %xmm1
	psrlq	$32, %xmm0
	pmuludq	%xmm2, %xmm1
	pmuludq	%xmm3, %xmm0
	pshufd	$8, %xmm1, %xmm1
	pshufd	$8, %xmm0, %xmm0
	punpckldq	%xmm0, %xmm1
	movdqu	(%rcx,%rax), %xmm0
	paddd	%xmm1, %xmm0
	movups	%xmm0, (%rcx,%rax)
	addq	$16, %rax
	cmpq	%r8, %rax
	jne	.L12
	cmpl	%ebx, %esi
	je	.L17
	movl	%esi, %eax
.L18:
	movl	(%rdx,%rax,4), %r10d
	imull	%r9d, %r10d
	addl	%r10d, (%rcx,%rax,4)
	addq	$1, %rax
	cmpl	%eax, %ebx
	jg	.L18
	addq	$4, %r11
	addq	%rbp, %rdx
	cmpq	%r11, %rdi
	jne	.L15
.L13:
	addl	$1, %r13d
	addq	%rbp, %rdi
	addq	%r15, %r14
	addq	%rbp, %rcx
	cmpl	%r13d, 60(%rsp)
	jne	.L16
	jmp	.L5
	.p2align 4,,10
	.p2align 3
.L17:
	addq	$4, %r11
	cmpq	%r11, %rdi
	je	.L13
	movl	(%r11), %r9d
	addq	%rbp, %rdx
	jmp	.L14
	.p2align 4,,10
	.p2align 3
.L23:
	xorl	%eax, %eax
	jmp	.L18
	.seh_endproc
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
	je	.L34
	pxor	%xmm0, %xmm0
	pxor	%xmm1, %xmm1
	cvtsi2sdq	40(%rsp), %xmm0
	cvtsi2sdq	timer_frequency(%rip), %xmm1
	divsd	%xmm1, %xmm0
	addq	$56, %rsp
	ret
.L34:
	movl	$1, %ecx
	call	exit
	nop
	.seh_endproc
	.section .rdata,"dr"
.LC1:
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
	je	.L37
	addq	$40, %rsp
	ret
.L37:
	leaq	.LC1(%rip), %rcx
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
.LC2:
	.ascii "r\0"
.LC3:
	.ascii "Error opening matrix file\0"
.LC4:
	.ascii "%d\0"
.LC5:
	.ascii "Error reading matrix values\12\0"
.LC6:
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
	leaq	.LC2(%rip), %rdx
	movl	%r8d, %edi
	call	fopen
	movq	%rax, %rsi
	testq	%rax, %rax
	je	.L40
	testl	%edi, %edi
	jle	.L41
	movl	%edi, %eax
	xorl	%r12d, %r12d
	leal	-1(%rdi), %ebp
	xorl	%r13d, %r13d
	movq	%rax, 40(%rsp)
	.p2align 4
	.p2align 3
.L42:
	leaq	(%r14,%r12,4), %rbx
	xorl	%r15d, %r15d
	jmp	.L45
	.p2align 4,,10
	.p2align 3
.L44:
	leal	1(%r15), %eax
	addq	$4, %rbx
	cmpl	%eax, %edi
	je	.L51
	movl	%eax, %r15d
.L45:
	movq	%rbx, %r8
	leaq	.LC4(%rip), %rdx
	movq	%rsi, %rcx
	call	fscanf
	cmpl	$1, %eax
	jne	.L52
	cmpl	%r15d, %ebp
	jle	.L44
	movq	%rsi, %rcx
	call	fgetc
	cmpl	$44, %eax
	je	.L44
	movl	$2, %ecx
	call	*__imp___acrt_iob_func(%rip)
	movl	$19, %r8d
	movl	$1, %edx
	leaq	.LC6(%rip), %rcx
	movq	%rax, %r9
.L50:
	call	fwrite
	movq	%rsi, %rcx
	call	fclose
	movl	$1, %ecx
	call	exit
	.p2align 4,,10
	.p2align 3
.L51:
	addq	40(%rsp), %r12
	cmpl	%r15d, %r13d
	je	.L41
	addl	$1, %r13d
	jmp	.L42
.L41:
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
.L52:
	movl	$2, %ecx
	call	*__imp___acrt_iob_func(%rip)
	movl	$28, %r8d
	movl	$1, %edx
	leaq	.LC5(%rip), %rcx
	movq	%rax, %r9
	jmp	.L50
.L40:
	leaq	.LC3(%rip), %rcx
	call	perror
	movl	$1, %ecx
	call	exit
	nop
	.seh_endproc
	.section .rdata,"dr"
.LC7:
	.ascii "w\0"
.LC8:
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
	leaq	.LC7(%rip), %rdx
	movl	%r8d, %r13d
	call	fopen
	movq	%rax, %rsi
	testq	%rax, %rax
	je	.L54
	testl	%r13d, %r13d
	jle	.L55
	movl	%r13d, %ebp
	leal	-1(%r13), %r12d
	xorl	%r15d, %r15d
	leaq	0(,%rbp,4), %r14
	.p2align 4
	.p2align 3
.L56:
	xorl	%ebx, %ebx
	.p2align 4
	.p2align 3
.L58:
	movl	(%rdi,%rbx,4), %r8d
	leaq	.LC4(%rip), %rdx
	movq	%rsi, %rcx
	call	fprintf
	cmpl	%ebx, %r12d
	jle	.L57
	movq	%rsi, %rdx
	movl	$44, %ecx
	call	fputc
.L57:
	addq	$1, %rbx
	cmpq	%rbx, %rbp
	jne	.L58
	movq	%rsi, %rdx
	movl	$10, %ecx
	addl	$1, %r15d
	addq	%r14, %rdi
	call	fputc
	cmpl	%r15d, %r13d
	jne	.L56
.L55:
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
.L54:
	leaq	.LC8(%rip), %rcx
	call	perror
	movl	$1, %ecx
	call	exit
	nop
	.seh_endproc
	.section .rdata,"dr"
.LC9:
	.ascii " <threads>\0"
.LC10:
	.ascii "Usage: %s <size>%s\12\0"
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
	.ascii "parallel\0"
	.align 8
.LC17:
	.ascii "RESULT,%s,%d,%d,%d,%d,%.9f,%llu\12\0"
.LC18:
	.ascii "results/parallel_%d_t%d.csv\0"
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
	subq	$408, %rsp
	.seh_stackalloc	408
	movups	%xmm6, 384(%rsp)
	.seh_savexmm	%xmm6, 384
	.seh_endprologue
	movq	%rdx, %rbx
	cmpl	$3, %ecx
	je	.L61
	movq	(%rdx), %rbx
	movl	$2, %ecx
	call	*__imp___acrt_iob_func(%rip)
	leaq	.LC9(%rip), %r9
	leaq	.LC10(%rip), %rdx
	movq	%rbx, %r8
	movq	%rax, %rcx
	call	fprintf
.L65:
	movl	$1, %eax
.L60:
	movups	384(%rsp), %xmm6
	addq	$408, %rsp
	popq	%rbx
	popq	%rsi
	popq	%rdi
	popq	%rbp
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	ret
.L61:
	movq	8(%rdx), %rcx
	call	positive_int
	movq	16(%rbx), %rcx
	movl	%eax, %esi
	call	positive_int
	movl	%eax, %edi
	movl	%eax, %r15d
	cmpl	$21474836, %esi
	jg	.L63
	xorl	%ecx, %ecx
	movl	%esi, %ebx
	call	omp_set_dynamic
	movl	%edi, %ecx
	imulq	%rbx, %rbx
	call	omp_set_num_threads
	movl	%esi, %ecx
	call	create_matrix
	movl	%esi, %ecx
	movq	%rax, %rdi
	call	create_matrix
	movl	%esi, %ecx
	movq	%rax, %rbp
	call	create_matrix
	movl	%esi, %r9d
	leaq	.LC11(%rip), %r8
	movl	$256, %edx
	leaq	128(%rsp), %rcx
	movq	%rax, %r12
	call	snprintf
	movl	%esi, %r8d
	movq	%rdi, %rdx
	leaq	128(%rsp), %rcx
	call	load_matrix
	movl	%esi, %r9d
	leaq	.LC12(%rip), %r8
	movl	$256, %edx
	leaq	128(%rsp), %rcx
	call	snprintf
	movl	%esi, %r8d
	movq	%rbp, %rdx
	leaq	128(%rsp), %rcx
	call	load_matrix
	xorl	%eax, %eax
	.p2align 4
	.p2align 3
.L64:
	cmpl	$10, (%rdi,%rax,4)
	ja	.L66
	cmpl	$10, 0(%rbp,%rax,4)
	ja	.L66
	addq	$1, %rax
	cmpq	%rbx, %rax
	jne	.L64
	leaq	timer_frequency(%rip), %rcx
	call	*__imp_QueryPerformanceFrequency(%rip)
	testl	%eax, %eax
	je	.L79
	leaq	-1(%rbx), %rcx
	movl	$-2, %eax
	movq	%rcx, 80(%rsp)
	movq	%rbx, %rcx
	shrq	$2, %rcx
	movq	%rcx, %r13
	movq	%rcx, 88(%rsp)
	salq	$4, %r13
	addq	%r12, %r13
.L68:
	movl	%eax, 76(%rsp)
	call	elapsed_seconds
	xorl	%r9d, %r9d
	xorl	%r8d, %r8d
	leaq	96(%rsp), %rdx
	leaq	matrix_multiplication._omp_fn.0(%rip), %rcx
	movapd	%xmm0, %xmm6
	movl	%esi, 120(%rsp)
	movq	%r12, 112(%rsp)
	movq	%rbp, 104(%rsp)
	movq	%rdi, 96(%rsp)
	movl	$1, 124(%rsp)
	call	GOMP_parallel
	movl	124(%rsp), %r14d
	call	elapsed_seconds
	cmpq	$2, 80(%rsp)
	movl	76(%rsp), %eax
	jbe	.L69
	movq	%r12, %rdx
	pxor	%xmm2, %xmm2
	.p2align 6
	.p2align 4
	.p2align 3
.L70:
	movdqu	(%rdx), %xmm1
	addq	$16, %rdx
	movdqa	%xmm1, %xmm3
	movdqa	%xmm1, %xmm4
	psrad	$31, %xmm3
	punpckldq	%xmm3, %xmm4
	punpckhdq	%xmm3, %xmm1
	paddq	%xmm4, %xmm1
	paddq	%xmm1, %xmm2
	cmpq	%rdx, %r13
	jne	.L70
	movdqa	%xmm2, %xmm1
	movq	88(%rsp), %rcx
	psrldq	$8, %xmm1
	paddq	%xmm1, %xmm2
	salq	$2, %rcx
	movq	%xmm2, %rdx
	cmpq	%rcx, %rbx
	je	.L71
.L72:
	movslq	(%r12,%rcx,4), %r8
	addq	$1, %rcx
	addq	%r8, %rdx
	cmpq	%rbx, %rcx
	jb	.L72
.L71:
	leal	1(%rax), %r10d
	testl	%eax, %eax
	js	.L73
	subsd	%xmm6, %xmm0
	movq	%rdx, 56(%rsp)
	movl	%r15d, %r9d
	movl	%esi, %r8d
	movl	%r10d, 40(%rsp)
	leaq	.LC16(%rip), %rdx
	leaq	.LC17(%rip), %rcx
	movl	%r14d, 32(%rsp)
	movsd	%xmm0, 48(%rsp)
	movl	%r10d, 76(%rsp)
	call	printf
	movl	76(%rsp), %r10d
	cmpl	$5, %r10d
	je	.L74
.L73:
	movl	%r10d, %eax
	jmp	.L68
.L66:
	movl	$2, %ecx
	call	*__imp___acrt_iob_func(%rip)
	movl	$31, %r8d
	movl	$1, %edx
	leaq	.LC14(%rip), %rcx
	movq	%rax, %r9
	call	fwrite
	movq	%rdi, %rcx
	call	free
	movq	%rbp, %rcx
	call	free
	movq	%r12, %rcx
	call	free
	jmp	.L65
.L63:
	movl	$2, %ecx
	call	*__imp___acrt_iob_func(%rip)
	movl	$47, %r8d
	movl	$1, %edx
	leaq	.LC13(%rip), %rcx
	movq	%rax, %r9
	call	fwrite
	jmp	.L65
.L74:
	movl	%r15d, 32(%rsp)
	movl	%esi, %r9d
	leaq	.LC18(%rip), %r8
	movl	$256, %edx
	leaq	128(%rsp), %rcx
	call	snprintf
	movl	%esi, %r8d
	movq	%r12, %rdx
	leaq	128(%rsp), %rcx
	call	save_matrix
	movq	%rdi, %rcx
	call	free
	movq	%rbp, %rcx
	call	free
	movq	%r12, %rcx
	call	free
	xorl	%eax, %eax
	jmp	.L60
.L69:
	movslq	(%r12), %rdx
	jmp	.L71
.L79:
	movl	$2, %ecx
	call	*__imp___acrt_iob_func(%rip)
	movl	$34, %r8d
	movl	$1, %edx
	leaq	.LC15(%rip), %rcx
	movq	%rax, %r9
	call	fwrite
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
	.def	strtol;	.scl	2;	.type	32;	.endef
	.def	fprintf;	.scl	2;	.type	32;	.endef
	.def	exit;	.scl	2;	.type	32;	.endef
	.def	GOMP_single_start;	.scl	2;	.type	32;	.endef
	.def	omp_get_num_threads;	.scl	2;	.type	32;	.endef
	.def	GOMP_barrier;	.scl	2;	.type	32;	.endef
	.def	omp_get_thread_num;	.scl	2;	.type	32;	.endef
	.def	memset;	.scl	2;	.type	32;	.endef
	.def	malloc;	.scl	2;	.type	32;	.endef
	.def	perror;	.scl	2;	.type	32;	.endef
	.def	free;	.scl	2;	.type	32;	.endef
	.def	fopen;	.scl	2;	.type	32;	.endef
	.def	fscanf;	.scl	2;	.type	32;	.endef
	.def	fgetc;	.scl	2;	.type	32;	.endef
	.def	fwrite;	.scl	2;	.type	32;	.endef
	.def	fclose;	.scl	2;	.type	32;	.endef
	.def	fputc;	.scl	2;	.type	32;	.endef
	.def	omp_set_dynamic;	.scl	2;	.type	32;	.endef
	.def	omp_set_num_threads;	.scl	2;	.type	32;	.endef
	.def	snprintf;	.scl	2;	.type	32;	.endef
	.def	GOMP_parallel;	.scl	2;	.type	32;	.endef
	.def	printf;	.scl	2;	.type	32;	.endef
