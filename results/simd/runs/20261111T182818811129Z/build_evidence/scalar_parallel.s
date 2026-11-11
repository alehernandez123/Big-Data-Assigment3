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
	subq	$56, %rsp
	.seh_stackalloc	56
	.seh_endprologue
	movq	8(%rcx), %rax
	movl	24(%rcx), %r14d
	movq	16(%rcx), %r15
	movq	%rax, 40(%rsp)
	movq	(%rcx), %rax
	movq	%rcx, %rbx
	movq	%rax, 32(%rsp)
	call	GOMP_single_start
	testb	%al, %al
	je	.L16
	call	omp_get_num_threads
	movl	%eax, 28(%rbx)
.L16:
	call	GOMP_barrier
	call	omp_get_num_threads
	movl	%eax, %ebx
	call	omp_get_thread_num
	movl	%eax, %r9d
	movl	%r14d, %eax
	cltd
	idivl	%ebx
	cmpl	%edx, %r9d
	leal	1(%rax), %edi
	cmovge	%eax, %edi
	movl	$0, %eax
	cmovl	%eax, %edx
	imull	%edi, %r9d
	leal	(%r9,%rdx), %r13d
	addl	%r13d, %edi
	cmpl	%edi, %r13d
	jge	.L5
	movslq	%r14d, %r12
	movslq	%r13d, %rax
	leaq	0(,%r12,4), %rbx
	leaq	1(%rax), %rsi
	movq	%rax, %rbp
	imulq	%rbx, %rax
	imulq	%r12, %rbp
	imulq	%rbx, %rsi
	addq	32(%rsp), %rsi
	leaq	(%r15,%rax), %rcx
.L10:
	testl	%r14d, %r14d
	jg	.L9
	addl	$1, %r13d
	addq	%rbx, %rsi
	addq	%r12, %rbp
	addq	%rbx, %rcx
	cmpl	%r13d, %edi
	jne	.L10
.L5:
	addq	$56, %rsp
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
	leal	-1(%r14), %eax
	leaq	4(,%rax,4), %r14
	.p2align 4
	.p2align 3
.L13:
	movq	%r14, %r8
	xorl	%edx, %edx
	call	memset
	movq	40(%rsp), %r8
	movq	%rax, %rcx
	movq	32(%rsp), %rax
	leaq	(%rax,%rbp,4), %r15
	.p2align 4
	.p2align 3
.L12:
	movl	(%r15), %r11d
	xorl	%eax, %eax
	.p2align 5
	.p2align 4
	.p2align 3
.L11:
	movl	(%r8,%rax), %edx
	imull	%r11d, %edx
	addl	%edx, (%rcx,%rax)
	addq	$4, %rax
	cmpq	%rax, %rbx
	jne	.L11
	addq	$4, %r15
	addq	%rbx, %r8
	cmpq	%rsi, %r15
	jne	.L12
	addl	$1, %r13d
	addq	%rbx, %rsi
	addq	%r12, %rbp
	addq	%rbx, %rcx
	cmpl	%r13d, %edi
	jne	.L13
	jmp	.L5
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
	je	.L24
	pxor	%xmm0, %xmm0
	pxor	%xmm1, %xmm1
	cvtsi2sdq	40(%rsp), %xmm0
	cvtsi2sdq	timer_frequency(%rip), %xmm1
	divsd	%xmm1, %xmm0
	addq	$56, %rsp
	ret
.L24:
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
	je	.L27
	addq	$40, %rsp
	ret
.L27:
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
	je	.L30
	testl	%edi, %edi
	jle	.L31
	movl	%edi, %eax
	xorl	%r12d, %r12d
	leal	-1(%rdi), %ebp
	xorl	%r13d, %r13d
	movq	%rax, 40(%rsp)
	.p2align 4
	.p2align 3
.L32:
	leaq	(%r14,%r12,4), %rbx
	xorl	%r15d, %r15d
	jmp	.L35
	.p2align 4,,10
	.p2align 3
.L34:
	leal	1(%r15), %eax
	addq	$4, %rbx
	cmpl	%eax, %edi
	je	.L41
	movl	%eax, %r15d
.L35:
	movq	%rbx, %r8
	leaq	.LC4(%rip), %rdx
	movq	%rsi, %rcx
	call	fscanf
	cmpl	$1, %eax
	jne	.L42
	cmpl	%r15d, %ebp
	jle	.L34
	movq	%rsi, %rcx
	call	fgetc
	cmpl	$44, %eax
	je	.L34
	movl	$2, %ecx
	call	*__imp___acrt_iob_func(%rip)
	movl	$19, %r8d
	movl	$1, %edx
	leaq	.LC6(%rip), %rcx
	movq	%rax, %r9
.L40:
	call	fwrite
	movq	%rsi, %rcx
	call	fclose
	movl	$1, %ecx
	call	exit
	.p2align 4,,10
	.p2align 3
.L41:
	addq	40(%rsp), %r12
	cmpl	%r15d, %r13d
	je	.L31
	addl	$1, %r13d
	jmp	.L32
.L31:
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
.L42:
	movl	$2, %ecx
	call	*__imp___acrt_iob_func(%rip)
	movl	$28, %r8d
	movl	$1, %edx
	leaq	.LC5(%rip), %rcx
	movq	%rax, %r9
	jmp	.L40
.L30:
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
	je	.L44
	testl	%r13d, %r13d
	jle	.L45
	movl	%r13d, %ebp
	leal	-1(%r13), %r12d
	xorl	%r15d, %r15d
	leaq	0(,%rbp,4), %r14
	.p2align 4
	.p2align 3
.L46:
	xorl	%ebx, %ebx
	.p2align 4
	.p2align 3
.L48:
	movl	(%rdi,%rbx,4), %r8d
	leaq	.LC4(%rip), %rdx
	movq	%rsi, %rcx
	call	fprintf
	cmpl	%ebx, %r12d
	jle	.L47
	movq	%rsi, %rdx
	movl	$44, %ecx
	call	fputc
.L47:
	addq	$1, %rbx
	cmpq	%rbx, %rbp
	jne	.L48
	movq	%rsi, %rdx
	movl	$10, %ecx
	addl	$1, %r15d
	addq	%r14, %rdi
	call	fputc
	cmpl	%r15d, %r13d
	jne	.L46
.L45:
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
.L44:
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
	subq	$384, %rsp
	.seh_stackalloc	384
	movups	%xmm6, 368(%rsp)
	.seh_savexmm	%xmm6, 368
	.seh_endprologue
	movq	%rdx, %rsi
	cmpl	$3, %ecx
	je	.L51
	movq	(%rdx), %rbx
	movl	$2, %ecx
	call	*__imp___acrt_iob_func(%rip)
	leaq	.LC9(%rip), %r9
	leaq	.LC10(%rip), %rdx
	movq	%rbx, %r8
	movq	%rax, %rcx
	call	fprintf
.L55:
	movl	$1, %eax
.L50:
	movups	368(%rsp), %xmm6
	addq	$384, %rsp
	popq	%rbx
	popq	%rsi
	popq	%rdi
	popq	%rbp
	popq	%r12
	popq	%r14
	popq	%r15
	ret
.L51:
	movq	8(%rdx), %rcx
	call	positive_int
	movq	16(%rsi), %rcx
	movl	%eax, %ebx
	call	positive_int
	movl	%eax, %edi
	movl	%eax, %r12d
	cmpl	$21474836, %ebx
	jg	.L53
	xorl	%ecx, %ecx
	movl	%ebx, %ebp
	call	omp_set_dynamic
	movl	%edi, %ecx
	call	omp_set_num_threads
	movl	%ebx, %ecx
	call	create_matrix
	movl	%ebx, %ecx
	movq	%rax, %rsi
	call	create_matrix
	movl	%ebx, %ecx
	movq	%rax, %rdi
	call	create_matrix
	movl	%ebx, %r9d
	movl	$256, %edx
	leaq	.LC11(%rip), %r8
	leaq	112(%rsp), %rcx
	movq	%rax, %r14
	call	snprintf
	movl	%ebx, %r8d
	movq	%rsi, %rdx
	leaq	112(%rsp), %rcx
	call	load_matrix
	movl	%ebx, %r9d
	movl	$256, %edx
	leaq	.LC12(%rip), %r8
	leaq	112(%rsp), %rcx
	call	snprintf
	movl	%ebx, %r8d
	movq	%rdi, %rdx
	leaq	112(%rsp), %rcx
	call	load_matrix
	movq	%rbp, %rax
	imulq	%rbp, %rax
	xorl	%ebp, %ebp
	.p2align 4
	.p2align 3
.L54:
	cmpl	$10, (%rsi,%rbp,4)
	ja	.L56
	cmpl	$10, (%rdi,%rbp,4)
	ja	.L56
	addq	$1, %rbp
	cmpq	%rax, %rbp
	jne	.L54
	leaq	timer_frequency(%rip), %rcx
	call	*__imp_QueryPerformanceFrequency(%rip)
	testl	%eax, %eax
	je	.L65
	leaq	(%r14,%rbp,4), %rbp
	movl	$-2, %r10d
.L62:
	movl	%r10d, 76(%rsp)
	call	elapsed_seconds
	leaq	80(%rsp), %rdx
	xorl	%r9d, %r9d
	xorl	%r8d, %r8d
	leaq	matrix_multiplication._omp_fn.0(%rip), %rcx
	movapd	%xmm0, %xmm6
	movl	%ebx, 104(%rsp)
	movq	%r14, 96(%rsp)
	movq	%rdi, 88(%rsp)
	movq	%rsi, 80(%rsp)
	movl	$1, 108(%rsp)
	call	GOMP_parallel
	movl	108(%rsp), %r15d
	call	elapsed_seconds
	movl	76(%rsp), %r10d
	movq	%r14, %rax
	xorl	%edx, %edx
	.p2align 4
	.p2align 4
	.p2align 3
.L59:
	movslq	(%rax), %rcx
	addq	$4, %rax
	addq	%rcx, %rdx
	cmpq	%rbp, %rax
	jne	.L59
	leal	1(%r10), %r11d
	testl	%r10d, %r10d
	js	.L60
	subsd	%xmm6, %xmm0
	movq	%rdx, 56(%rsp)
	movl	%r12d, %r9d
	movl	%ebx, %r8d
	movl	%r11d, 40(%rsp)
	leaq	.LC16(%rip), %rdx
	leaq	.LC17(%rip), %rcx
	movl	%r15d, 32(%rsp)
	movsd	%xmm0, 48(%rsp)
	movl	%r11d, 76(%rsp)
	call	printf
	movl	76(%rsp), %r11d
	cmpl	$5, %r11d
	je	.L61
.L60:
	movl	%r11d, %r10d
	jmp	.L62
.L56:
	movl	$2, %ecx
	call	*__imp___acrt_iob_func(%rip)
	movl	$31, %r8d
	movl	$1, %edx
	leaq	.LC14(%rip), %rcx
	movq	%rax, %r9
	call	fwrite
	movq	%rsi, %rcx
	call	free
	movq	%rdi, %rcx
	call	free
	movq	%r14, %rcx
	call	free
	jmp	.L55
.L53:
	movl	$2, %ecx
	call	*__imp___acrt_iob_func(%rip)
	movl	$47, %r8d
	movl	$1, %edx
	leaq	.LC13(%rip), %rcx
	movq	%rax, %r9
	call	fwrite
	jmp	.L55
.L61:
	movl	%r12d, 32(%rsp)
	movl	%ebx, %r9d
	movl	$256, %edx
	leaq	.LC18(%rip), %r8
	leaq	112(%rsp), %rcx
	call	snprintf
	movl	%ebx, %r8d
	movq	%r14, %rdx
	leaq	112(%rsp), %rcx
	call	save_matrix
	movq	%rsi, %rcx
	call	free
	movq	%rdi, %rcx
	call	free
	movq	%r14, %rcx
	call	free
	xorl	%eax, %eax
	jmp	.L50
.L65:
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
