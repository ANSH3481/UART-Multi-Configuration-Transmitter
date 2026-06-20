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

The transmitter was verified for:

### Test 1: No Parity
Result: PASS

### Test 2: Odd Parity
Result: PASS

### Test 3: Even Parity
Result: PASS

---

## Simulation Results

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
