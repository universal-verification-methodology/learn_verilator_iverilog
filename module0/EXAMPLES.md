# Module 0 Examples

Hands-on examples for **Installation and Setup**: first iverilog and Verilator testbenches, tool comparison.

---

## 1. iverilog basics (`iverilog_basics/`)

Hello-world compile and simulation with Icarus Verilog.

```bash
cd module0/examples/iverilog_basics
make hello_world
```

---

## 2. Verilator basics (`verilator_basics/`)

First C++ testbench flow with Verilator (requires `verilator` on PATH).

```bash
cd module0/examples/verilator_basics
make hello_world
```

---

## 3. Tool comparison (`comparison/`)

Compare iverilog vs Verilator workflow for the same DUT.

```bash
cd module0/examples/comparison
ls -la
head -30 README.md 2>/dev/null || head -30 Makefile
```
