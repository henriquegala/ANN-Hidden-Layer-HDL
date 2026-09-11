# ANN Hidden Layer — SystemVerilog & VHDL Implementation

> Developed during a summer research internship at the Instituto de Telecomunicações (IT).

## Overview
A synchronous hidden layer with **10 parallel neurons, 4 inputs each**, implemented in full parity in both **SystemVerilog and VHDL**, with two selectable activation functions:

- **ReLU** — 3-stage pipeline.
- **Sigmoid** — 4-stage pipeline, ROM-based (256 entries).

Arithmetic uses **Q8.8 fixed-point** (16-bit, 8 integer + 8 fractional bits, two's complement, scale 256 — e.g. `1.0 decimal = 256 = 0x0100`).

## Sigmoid ROM Address Mapping
```
addr = (sum_total + 1024) >> 3
```
Covers the range **[-4.0, +4.0]** in Q8.8 (`[-1024, +1023]`), with saturation/clamping outside that range:
- `sum ≤ -1024` → `y = 0x0000`
- `sum ≥ +1024` → `y = 0x0100`

## Key Engineering Problem: Pipeline Alignment
Products (`x·w`) take 2 cycles to become ready in the pipeline. The bias and saturation flags (`sat_low`/`sat_high`) needed extra registers (`b_reg→b_reg2`, `sat_reg→sat_reg2`) to arrive time-aligned with the signals they combine with. Without this, continuous streaming (one new sample per cycle) would mix data from different samples.

Validated by:
- **Simulation** — test vectors with different bias values on consecutive cycles.
- **Synthesis** — no timing violations.

## Verification (Simulation — Vivado XSim)
SystemVerilog testbench with 8 test vectors (4 straightforward + 4 randomized, including saturation cases), behavioral simulation. Latencies confirmed on the waveform: **3 cycles (ReLU)**, **4 cycles (Sigmoid)**. All vectors matched prior manual calculation exactly.

## Synthesis Results
Vivado 2025.2, FPGA **Artix-7 xc7a35tcpg236-1**, Out-of-Context mode (due to 1026 I/O ports on the block).

| Metric                  | ReLU          | Sigmoid        |
|--------------------------|---------------|----------------|
| Slice LUTs               | 680 (3.27%)   | 1090 (5.24%)   |
| Slice Registers (FFs)    | 1280 (3.08%)  | 1320 (3.17%)   |
| DSPs                     | 40 (44.44%)   | 40 (44.44%)    |
| Block RAM                | 0             | 0               |
| Fmax                     | ≈132.7 MHz    | ≈128.75 MHz    |

**Key finding:** the sigmoid ROM does **not** use Block RAM — it synthesizes to distributed logic (MUXF7/MUXF8 + LUTs), one ROM instance replicated per neuron rather than centralized. The sigmoid variant's critical path does not run through the ROM (fast, 1 logic level) — it runs through the saturation-flag comparison tree (10 levels: 6×CARRY4 + LUT2 + 2×LUT5 + LUT6), which explains why Fmax only drops ~3% despite a ~60% increase in LUTs.

## Repository Structure
```
systemverilog/   SystemVerilog RTL + testbench (8 test vectors)
vhdl/             VHDL equivalent
tools/            Simulation/synthesis scripts (Vivado .tcl)
reports/          Synthesis utilization/timing reports, simulation waveforms
docs/             Presentation slides + technical notes
```

## Status
Project complete: simulated, synthesized, and presented (01/08/2026). This repository packages that work for portfolio purposes.
