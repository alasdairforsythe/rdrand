// +build amd64

#include "textflag.h"

// Uint generates a 64-bit random number using the RDRAND instruction.
// func Uint() (val uint64, ok bool)
TEXT ·Uint(SB), NOSPLIT, $0-16
    // Emit RDRAND AX (0F C7 F0)
    BYTE $0x0F
    BYTE $0xC7
    BYTE $0xF0
    JC success
    MOVQ $0, ret+0(FP)
    MOVB $0, ret+8(FP)
    RET
success:
    MOVQ AX, ret+0(FP)
    MOVB $1, ret+8(FP)
    RET

// UintN returns a random uint64 in [0, n), using RDRAND.
// func UintN(n uint64) (val uint64, ok bool)
TEXT ·UintN(SB), NOSPLIT, $0-24
    // Load n
    MOVQ n+0(FP), BX
retry:
    // RDRAND AX (0F C7 F0)
    BYTE $0x0F
    BYTE $0xC7
    BYTE $0xF0
    JNC fail

    // Compute (2^64 - n) % n
    MOVQ BX, CX
    NEGQ CX
    ANDQ BX, CX

    // Multiply AX * BX => DX:AX
    MULQ BX

    // Reject if result >= threshold
    CMPQ DX, CX
    JAE retry

    // Success
    MOVQ DX, ret+8(FP)
    MOVB $1, ret+16(FP)
    RET
fail:
    MOVQ $0, ret+8(FP)
    MOVB $0, ret+16(FP)
    RET
