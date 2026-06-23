# UART Multi-Configuration Transmitter

## Overview

This project implements a UART (Universal Asynchronous Receiver Transmitter) Transmitter in Verilog HDL with configurable parity support.

Supported modes:
- No Parity
- Odd Parity
- Even Parity

The design is verified using a SystemVerilog testbench and simulated using Icarus Verilog and EPWave.

---

## Features

- UART serial transmission
- Configurable parity selection
- FSM-based design
- Verilog RTL implementation
- SystemVerilog verification environment
- Functional simulation and waveform analysis

---

## Project Structure

```text
rtl/
└── uart_tx.v

tb/
└── tb_uart_tx.sv

uart_tx_waveform.png
simulation_output.png
README.md
```

---

## FSM States

- IDLE
- START
- DATA
- PARITY
- STOP

---

## Verification

The SystemVerilog testbench captures the serial TX output, reconstructs the transmitted frame, verifies data integrity, checks parity correctness, and automatically reports PASS/FAIL results.

### Test 1: No Parity
- Data transmitted: 0x55
- Data reconstructed from TX line: 0x55
- Stop bit verified
- Result: PASS

### Test 2: Odd Parity
- Data transmitted: 0xA5
- Data reconstructed from TX line: 0xA5
- Odd parity verified
- Stop bit verified
- Result: PASS

### Test 3: Even Parity
- Data transmitted: 0x3C
- Data reconstructed from TX line: 0x3C
- Even parity verified
- Stop bit verified
- Result: PASS

---

## Simulation Results

The transmitted serial frame was reconstructed from the TX line and verified against the expected data and parity values. All test cases passed successfully.

Console output screenshot:
- simulation_output.png

Waveform screenshot:
- uart_tx_waveform.png

---

## Tools Used

- Verilog HDL
- SystemVerilog
- Icarus Verilog
- EDA Playground
- EPWave
- GitHub

---

## Author

Ansh Gupta  
B.Tech Electronics and Communication Engineering (ECE)
