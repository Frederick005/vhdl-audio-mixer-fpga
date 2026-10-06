# VHDL Audio Mixer — FPGA Implementation

A **4-channel TDM audio mixer** designed and synthesized in **VHDL for a Lattice XP2 FPGA**. The project implements fixed-point gain processing, channel summation, master volume control and hardware resource optimization, followed by simulation, verification and synthesis.

## 🛠️ Skills & Technologies

**HDL:** VHDL, RTL Design
**FPGA:** Lattice XP2
**Simulation & Verification:** ModelSim, VHDL Testbench
**Synthesis:** Lattice Diamond, Synplify
**Data Processing:** MATLAB, Anaconda
**Digital Design:** TDM, Serial-to-Parallel Conversion, Fixed-Point Arithmetic
**Hardware Optimization:** Multiplier Reuse, Resource Optimization, Bit Truncation
**Verification:** Functional Verification, Simulation, Manual Validation
**Engineering:** Requirements Analysis, V-Cycle Development, RTL/Dataflow Modeling

---

## 🚀 Project Overview

The objective was to design an FPGA-based audio mixer capable of processing **four serial TDM input channels** and producing **two output channels**.

The system operates with:

* **4 input audio channels**
* **2 output channels**
* **48 kHz frame rate**
* **16-bit input samples**
* **24-bit output samples**
* **10-bit gain factors**
* Fixed-point input, gain and output representations
* A maximum of **two hardware multipliers**

Each input channel is independently scaled using channel-specific gain factors. The resulting channels are summed into two output paths and subsequently scaled using independent master volume controls.

---

## 🧩 System Architecture

The processing flow can be summarized as:

```text
                TDM Serial Input
                       │
                       ▼
              Serial-to-Parallel
                 16-bit Channels
                       │
          ┌────────────┼────────────┐
          ▼            ▼            ▼
       Channel 1    Channel 2    Channel 3 ... Channel 4
          │            │            │
          └────────────┼────────────┘
                       ▼
              Individual Gain
                       │
                       ▼
              Channel Summation
                 ┌─────┴─────┐
                 ▼           ▼
              Output A     Output B
                 │           │
                 ▼           ▼
             Master Gain  Master Gain
                 │           │
                 ▼           ▼
              24-bit       24-bit
               Output       Output
```

The VHDL design uses a custom multiplication function to perform signed channel/gain multiplication and stores the intermediate results for subsequent processing.

---

## 🎚️ Gain and Fixed-Point Processing

The mixer uses fixed-point representations for signal processing.

The design handles:

* Signed and unsigned values
* Two's-complement representation
* Fixed-point multiplication
* Bit-width expansion during arithmetic
* Overflow considerations
* Intermediate truncation
* Output-width reduction

The input audio samples use a **1.15 fixed-point representation**, while the output uses **1.23 fixed-point representation**. Gain values use a **5.5 fixed-point representation**.

---

## ⚙️ Hardware Resource Optimization

A key design constraint was limiting the implementation to **two hardware multipliers**.

Directly multiplying the accumulated channel data by the master gain would have required additional multiplier resources. To address this, the intermediate summed signals were truncated before the master-gain multiplication.

This allowed the existing multiplier resources to be reused while maintaining the required output width.

The optimization involved:

1. Multiplying each input channel by its respective gain.
2. Summing the four channel products.
3. Truncating the intermediate result.
4. Reusing the multiplier resources for master-volume scaling.
5. Truncating the final result to the required 24-bit output.

This provided hands-on experience with **FPGA resource constraints, datapath design and hardware optimization**.

---

## 🧪 Verification & Testbench

A dedicated VHDL testbench was developed to verify the design.

The testbench:

* Instantiates the Audio Mixer as the **Design Under Test (DUT)**
* Provides serial input data
* Supplies channel and master gain values
* Processes multiple audio channels
* Reads test data from files
* Captures the generated output
* Supports comparison of simulation results with expected values

Audio test data was generated from `.wav` files using **MATLAB**, converted into the required binary/TDM representation and supplied to the VHDL testbench.

The generated output bitstream was subsequently processed to reconstruct the resulting audio.

---

## 🔬 Verification & Validation

The implementation was verified using multiple approaches:

### Simulation

The VHDL design and testbench were simulated using **ModelSim** to observe signal processing and verify the expected output.

### Manual Verification

Intermediate values were independently calculated and compared against the values produced by the VHDL simulation.

This included verification of:

* Individual gain multiplication
* Channel summation
* Intermediate truncation
* Master gain multiplication
* Final output truncation

### Audio Validation

Input `.wav` files were converted to TDM bitstreams, processed through the VHDL design and converted back into audio for validation.

---

## 🔧 Synthesis & RTL Analysis

The design was synthesized for a **Lattice XP2 FPGA** using **Lattice Diamond**.

**Synplify** was used to generate and inspect the synthesized RTL representation.

The project included analysis of:

* Physical implementation
* FPGA floor planning
* RTL structure
* Dataflow
* Hardware multiplier usage
* Synthesized design architecture

---

## 🔄 Development Methodology

The project followed a simplified **V-Cycle development approach**:

```text
Requirements
     │
     ▼
System / RTL Design
     │
     ▼
VHDL Implementation
     │
     ▼
Simulation & Verification
     │
     ▼
Synthesis
     │
     ▼
Validation
```

The development process involved iterations between requirements analysis, design and verification to resolve implementation and interpretation issues.

---
