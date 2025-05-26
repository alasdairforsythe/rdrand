// Package rdrand provides hardware random number generation using CPU instructions.
package rdrand

// Gen64 generates a 64-bit random number using the RDRAND instruction.
// Returns the random number and a boolean indicating success.
func Gen64() (uint64, bool)

// Gen generates a random number between 0 and n (exclusive) using RDRAND.
func Gen(n uint64) (uint64, bool)