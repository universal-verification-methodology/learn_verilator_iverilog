# Verilator Limitations and C++ Alternatives

This document outlines SystemVerilog features that work well with iverilog but have limitations in Verilator, along with C++ equivalent patterns.

## SystemVerilog Classes

### iverilog Support
- ✅ Full class support
- ✅ Inheritance
- ✅ Polymorphism
- ✅ Virtual methods

### Verilator Limitations
- ❌ Limited class support
- ❌ No inheritance
- ❌ No polymorphism

### C++ Alternative
Use C++ classes directly:
```cpp
class Transaction {
    // C++ class implementation
};
```

## Randomization

### iverilog Support
- ✅ `rand` and `randc` keywords
- ✅ Constraint blocks
- ✅ `randomize()` method
- ✅ `$random()` and `$urandom()`

### Verilator Limitations
- ❌ No `rand`/`randc` support
- ❌ No constraint blocks
- ❌ No `randomize()` method

### C++ Alternative
Use C++ random number generators:
```cpp
#include <random>
std::mt19937 gen;
std::uniform_int_distribution<> dis(0, 255);
uint8_t value = dis(gen);
```

## Interfaces

### iverilog Support
- ✅ Interface declarations
- ✅ Modports
- ✅ Virtual interfaces
- ✅ Interface arrays

### Verilator Limitations
- ❌ Limited interface support
- ❌ No modports
- ❌ No virtual interfaces

### C++ Alternative
Use structs to group signals:
```cpp
struct Interface {
    uint8_t signal1;
    uint8_t signal2;
};
```

## Advanced Data Types

### iverilog Support
- ✅ Dynamic arrays
- ✅ Associative arrays
- ✅ Queues
- ✅ Structures and unions
- ✅ Enumerated types

### Verilator Limitations
- ❌ Limited dynamic array support
- ❌ No associative arrays
- ❌ No queues

### C++ Alternative
Use C++ STL containers:
```cpp
std::vector<int> dyn_array;      // Dynamic array
std::map<int, int> assoc_array;  // Associative array
std::deque<int> queue;            // Queue
```

## Packages

### iverilog Support
- ✅ Package declarations
- ✅ Package imports
- ✅ Namespace management

### Verilator Limitations
- ❌ Limited package support

### C++ Alternative
Use C++ namespaces:
```cpp
namespace testbench_pkg {
    // Shared definitions
}
```

## Recommendations

1. **For iverilog**: Use full SystemVerilog features
2. **For Verilator**: Use C++ equivalents
3. **For portability**: Use basic Verilog/C++ patterns
4. **For advanced features**: Consider tool-specific implementations
