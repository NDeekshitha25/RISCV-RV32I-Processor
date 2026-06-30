# RISC-V RV32I Processor

A modular RTL implementation of a **5-stage pipelined RISC-V RV32I processor** developed as part of the **Texas Instruments Digital Bootcamp (WiSH 2026)**.

The project focuses on implementing core processor modules in **SystemVerilog**, verifying their functionality using Python-based testbenches, and debugging through **GTKWave** waveform analysis.

---

## Features

- 5-stage pipelined RV32I processor
- Modular SystemVerilog RTL implementation
- Instruction Fetch (IFU)
- Instruction Decode (IDU)
- Integer Execution Unit (IEU)
- ALU and ALU Core
- Register File
- Branch and Jump Units
- Load and Store Units
- Memory Interface
- Instruction/Data Arbiter
- Module-level verification using Python testbenches
- Waveform debugging using GTKWave

---

## Repository Structure

```
RISCV-RV32I-Processor
│
├── rtl/                # SystemVerilog RTL modules
│
├── tb/                 # Python testbenches and Makefile
│
├── .gitignore
└── README.md
```

---

## Verification

Each RTL module is verified individually using the provided Python-based testbenches. Simulations are executed through the supplied Makefile, and functional correctness is validated by analyzing generated waveforms in GTKWave.

---

## Tools Used

- SystemVerilog
- Python
- GTKWave
- GNU Make
- VS Code
- Ubuntu

---

## Implemented Modules

- alu.sv
- alu_core.sv
- ifu.sv
- idu.sv
- ieu.sv
- regfile.sv
- branch.sv
- jump.sv
- load.sv
- store.sv
- mem.sv
- inst_data_arbiter.sv
- decode_branch_inst.sv
- decode_imm_inst.sv
- decode_jump_inst.sv
- decode_load_inst.sv
- decode_reg_inst.sv
- decode_store_inst.sv
- decode_upperimm_inst.sv

---

## Learning Outcomes

- RTL design using SystemVerilog
- Modular processor design
- Combinational and sequential logic implementation
- Module-level verification methodology
- Waveform-based debugging using GTKWave
- Understanding of the RISC-V RV32I instruction set architecture
