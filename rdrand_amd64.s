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

// func UintN(n uint64) (val uint64, ok bool)
TEXT ·UintN(SB), NOSPLIT, $0-24
	MOVQ n+0(FP), BX
	TESTQ BX, BX
	JZ fastzero

	// Compute n-1 for comparison
	MOVQ BX, R8
	DECQ R8

retry:
	// RDRAND to AX: 0F C7 F0
	BYTE $0x0F; BYTE $0xC7; BYTE $0xF0
	JNC fail

	// AX contains the random value
	// Compute random % n
	MOVQ AX, CX
	XORQ DX, DX    // Clear DX for division
	DIVQ BX        // Divide CX by BX, quotient in AX, remainder in DX

	// Check if remainder (DX) is valid
	CMPQ DX, R8
	JA retry       // If remainder > n-1, retry

	// Store results
	MOVQ DX, val+8(FP)  // Return remainder as val
	MOVB $1, ok+16(FP)  // Return true for ok
	RET

fastzero:
	MOVQ $0, val+8(FP)
	MOVB $1, ok+16(FP)
	RET

fail:
	MOVQ $0, val+8(FP)
	MOVB $0, ok+16(FP)
	RET
