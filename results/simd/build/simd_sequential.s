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
	subq	$424, %rsp
	.seh_stackalloc	424
	movups	%xmm6, 400(%rsp)
	.seh_savexmm	%xmm6, 400
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
	movl	$1, %r12d
.L30:
	movups	400(%rsp), %xmm6
	movl	%r12d, %eax
	addq	$424, %rsp
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
	leaq	144(%rsp), %rdx
	call	strtol
	movl	%eax, %ebx
	call	*%rdi
	movl	(%rax), %r12d
	testl	%r12d, %r12d
	jne	.L33
	cmpb	$0, (%rsi)
	je	.L33
	movq	144(%rsp), %rax
	cmpb	$0, (%rax)
	jne	.L33
	testl	%ebx, %ebx
	jle	.L33
	cmpl	$21474836, %ebx
	jg	.L68
	xorl	%ecx, %ecx
	movl	%ebx, %edi
	call	omp_set_dynamic
	movl	$1, %ecx
	movq	%rdi, %r15
	call	omp_set_num_threads
	movl	%ebx, %ecx
	imulq	%rdi, %r15
	call	create_matrix
	movl	%ebx, %ecx
	movq	%rax, %rsi
	movq	%rax, 80(%rsp)
	call	create_matrix
	movl	%ebx, %ecx
	movq	%rax, %rbp
	call	create_matrix
	movl	%ebx, %r9d
	leaq	.LC11(%rip), %r8
	movl	$256, %edx
	leaq	144(%rsp), %rcx
	movq	%rax, 72(%rsp)
	call	snprintf
	movl	%ebx, %r8d
	movq	%rsi, %rdx
	leaq	144(%rsp), %rcx
	call	load_matrix
	movl	%ebx, %r9d
	leaq	.LC12(%rip), %r8
	movl	$256, %edx
	leaq	144(%rsp), %rcx
	call	snprintf
	movq	%rbp, %rdx
	movl	%ebx, %r8d
	leaq	144(%rsp), %rcx
	call	load_matrix
	xorl	%eax, %eax
	movq	%rsi, %rdx
.L36:
	cmpl	$10, (%rdx,%rax,4)
	ja	.L38
	cmpl	$10, 0(%rbp,%rax,4)
	ja	.L38
	addq	$1, %rax
	cmpq	%r15, %rax
	jne	.L36
	leaq	timer_frequency(%rip), %rcx
	call	*__imp_QueryPerformanceFrequency(%rip)
	testl	%eax, %eax
	je	.L69
	leaq	-1(%r15), %rax
	movq	72(%rsp), %rdx
	movq	%r15, 112(%rsp)
	movl	%ebx, %esi
	movq	%rax, 96(%rsp)
	movl	%ebx, %eax
	salq	$2, %rdi
	leal	-1(%rbx), %r13d
	shrl	$2, %eax
	movl	$-2, 92(%rsp)
	andl	$-4, %esi
	movl	%eax, 120(%rsp)
	movq	%r15, %rax
	shrq	$2, %rax
	movl	%r12d, 124(%rsp)
	movq	%rax, 104(%rsp)
	salq	$4, %rax
	leaq	(%rdx,%rax), %r10
	movq	%r10, 128(%rsp)
.L57:
	call	elapsed_seconds
	movq	72(%rsp), %rcx
	movq	80(%rsp), %r12
	xorl	%r14d, %r14d
	movl	120(%rsp), %r15d
	movapd	%xmm0, %xmm6
	movq	%rcx, 136(%rsp)
	.p2align 4
	.p2align 3
.L41:
	xorl	%edx, %edx
	movq	%rdi, %r8
	call	memset
	movl	%r15d, %r9d
	movq	%rbp, %rdx
	xorl	%r11d, %r11d
	movq	%rax, %rcx
	salq	$4, %r9
	.p2align 4
	.p2align 3
.L49:
	movl	(%r12,%r11,4), %r8d
	cmpl	$2, %r13d
	jbe	.L58
.L48:
	movd	%r8d, %xmm5
	xorl	%eax, %eax
	pshufd	$0, %xmm5, %xmm2
	movdqa	%xmm2, %xmm3
	psrlq	$32, %xmm3
	.p2align 6
	.p2align 4
	.p2align 3
.L43:
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
	cmpq	%r9, %rax
	jne	.L43
	cmpl	%esi, %ebx
	je	.L44
	movl	%esi, %eax
.L45:
	movl	(%rdx,%rax,4), %r10d
	imull	%r8d, %r10d
	addl	%r10d, (%rcx,%rax,4)
	addq	$1, %rax
	cmpl	%eax, %ebx
	jg	.L45
	addq	$1, %r11
	addq	%rdi, %rdx
	cmpl	%r11d, %ebx
	jg	.L49
.L47:
	addl	$1, %r14d
	addq	%rdi, %rcx
	addq	%rdi, %r12
	cmpl	%r14d, %ebx
	jg	.L41
	movq	136(%rsp), %r15
	call	elapsed_seconds
	movapd	%xmm0, %xmm4
	cmpq	$2, 96(%rsp)
	jbe	.L51
	movq	128(%rsp), %r10
	pxor	%xmm1, %xmm1
	.p2align 6
	.p2align 4
	.p2align 3
.L52:
	movdqu	(%r15), %xmm0
	addq	$16, %r15
	movdqa	%xmm0, %xmm2
	movdqa	%xmm0, %xmm3
	psrad	$31, %xmm2
	punpckhdq	%xmm2, %xmm3
	punpckldq	%xmm2, %xmm0
	paddq	%xmm3, %xmm0
	paddq	%xmm0, %xmm1
	cmpq	%r10, %r15
	jne	.L52
	movdqa	%xmm1, %xmm0
	movq	104(%rsp), %rax
	movq	112(%rsp), %r8
	psrldq	$8, %xmm0
	paddq	%xmm0, %xmm1
	salq	$2, %rax
	movq	%xmm1, %rdx
	cmpq	%r8, %rax
	je	.L53
	movq	72(%rsp), %r9
.L54:
	movslq	(%r9,%rax,4), %rcx
	addq	$1, %rax
	addq	%rcx, %rdx
	cmpq	%r8, %rax
	jb	.L54
.L53:
	movl	92(%rsp), %eax
	leal	1(%rax), %r12d
	testl	%eax, %eax
	js	.L55
	subsd	%xmm6, %xmm4
	movq	%rdx, 56(%rsp)
	movl	$1, %r9d
	movl	%ebx, %r8d
	movl	%r12d, 40(%rsp)
	leaq	.LC16(%rip), %rdx
	leaq	.LC17(%rip), %rcx
	movl	$1, 32(%rsp)
	movsd	%xmm4, 48(%rsp)
	call	printf
	cmpl	$5, %r12d
	je	.L56
.L55:
	movl	%r12d, 92(%rsp)
	jmp	.L57
	.p2align 4,,10
	.p2align 3
.L44:
	addq	$1, %r11
	cmpl	%r11d, %ebx
	jle	.L47
	movl	(%r12,%r11,4), %r8d
	addq	%rdi, %rdx
	jmp	.L48
	.p2align 4,,10
	.p2align 3
.L58:
	xorl	%eax, %eax
	jmp	.L45
.L38:
	movl	$2, %ecx
	call	*__imp___acrt_iob_func(%rip)
	movl	$31, %r8d
	movl	$1, %edx
	leaq	.LC14(%rip), %rcx
	movq	%rax, %r9
	call	fwrite
	movq	80(%rsp), %rcx
	call	free
	movq	%rbp, %rcx
	call	free
	movq	72(%rsp), %rcx
	call	free
	jmp	.L37
.L68:
	movl	$2, %ecx
	call	*__imp___acrt_iob_func(%rip)
	movl	$47, %r8d
	movl	$1, %edx
	leaq	.LC13(%rip), %rcx
	movq	%rax, %r9
	call	fwrite
	jmp	.L37
.L56:
	movl	%ebx, %r9d
	movl	$256, %edx
	movl	124(%rsp), %r12d
	leaq	144(%rsp), %rcx
	leaq	.LC18(%rip), %r8
	call	snprintf
	movq	72(%rsp), %rdi
	movl	%ebx, %r8d
	leaq	144(%rsp), %rcx
	movq	%rdi, %rdx
	call	save_matrix
	movq	80(%rsp), %rcx
	call	free
	movq	%rbp, %rcx
	call	free
	movq	%rdi, %rcx
	call	free
	jmp	.L30
.L51:
	movq	72(%rsp), %rax
	movslq	(%rax), %rdx
	jmp	.L53
.L69:
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
