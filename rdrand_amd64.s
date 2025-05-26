// +build amd64

// Package rdrand provides hardware random number generation using RDRAND instruction.
package rdrand

// Gen generates a 64-bit random number using RDRAND instruction.
// Returns the random number and a boolean indicating success.
// If the CPU doesn't support RDRAND or the instruction fails, returns 0 and false.
TEXT ·Gen64(SB),$0-16
    RDRAND AX
    JC success
    MOVQ $0, ret+0(FP)
    MOVB $0, ret+8(FP)
    RET
success:
    MOVQ AX, ret+0(FP)
    MOVB $1, ret+8(FP)
    RET

// GenN generates a random number between 0 and n (exclusive) using RDRAND.
// Takes n as input (uint64). Returns the random number and a boolean indicating success.
// Uses multiplication-based scaling for performance, optimized for minimal branching.
// If RDRAND fails, returns 0 and false. Undefined behavior if n is 0.
TEXT ·Gen(SB),$0-24
    // Load n
    MOVQ n+0(FP), BX
retry:
    // Generate random number
    RDRAND AX
    JNC fail
    // Compute threshold: (2^64 - n) % n
    MOVQ BX, CX
    NEGQ CX
    ANDQ BX, CX
    // Scale: result = (random * n) >> 64
    MULQ BX
    // Check if result >= threshold
    CMPQ DX, CX
    JAE retry
    // Store result and success
    MOVQ DX, ret+8(FP)
    MOVB $1, ret+16(FP)
    RET
fail:
    MOVQ $0, ret+8(FP)
    MOVB $0, ret+16(FP)
    RET
