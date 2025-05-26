# rdrand
Fastest random number generator for Go using assembly. Currently only supports x86_64.

## Usage
```go
package main
import "github.com/alasdairforsythe/rdrand"

func main() {
  a := rdrand.Uint() // random Uint64
  b := rdrand.UintN(100) // random Uint64 between 0-99
}
```
