// Package rdrand provides hardware random number generation using CPU instructions.
package rdrand

// Uint generates a 64-bit random number using the RDRAND instruction.
// Returns the random number and a boolean indicating success.
func Uint() (uint64, bool)

// Gen generates a random number between 0 and n (exclusive) using RDRAND.
func UintN(n uint64) (uint64, bool)

// Generates a floating point number between 0 and 1
func Float32() (float32, bool)
