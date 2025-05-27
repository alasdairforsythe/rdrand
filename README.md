# rdrand
Random number generator for Go using CPU RDRAND instructions.

## Usage
```go
package main
import "github.com/alasdairforsythe/rdrand"

func main() {
  a := rdrand.Uint() // random Uint64
  b := rdrand.UintN(100) // random Uint64 between 0-99
}
```
