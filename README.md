# UART DUT Verification

A SystemVerilog-based functional verification project for the UART (Universal Asynchronous Receiver Transmitter) protocol using a custom testbench environment (non-UVM).

---

## Project Structure

```
UART_DUT_verification/
└── UART/
    ├── rtl/
    │   ├── uart_top.sv         # Top-level UART module (instantiates uarttx and uartrx)
    │   └── uart_if.sv          # Interface definition with clocking blocks and modports
    ├── testbench/
    │   ├── uart_transaction.sv # Transaction class with randomized data fields
    │   ├── uart_generator.sv   # Generator: randomizes and sends transactions
    │   ├── uart_driver.sv      # Driver: drives transactions onto the DUT interface
    │   ├── uart_monitor.sv     # Monitor: samples TX/RX data from the interface
    │   ├── uart_scoreboard.sv  # Scoreboard: compares TX vs RX data
    │   ├── uart_environment.sv # Environment: connects all testbench components
    │   ├── base_test.sv        # Base test: instantiates environment and starts simulation
    │   ├── sim_files_pkg.sv    # Package: includes all testbench files
    │   └── tb_top.sv           # Top-level testbench module
    └── simulation/
        └── run.do              # ModelSim/Questa simulation script
```

---

## Component Descriptions

| Component | File | Description |
|---|---|---|
| **DUT Top** | `uart_top.sv` | Instantiates UART TX and RX modules |
| **UART TX** | `uart_top.sv` | Serializes 8-bit data and transmits over TX line |
| **UART RX** | `uart_top.sv` | Deserializes received serial data back to 8-bit |
| **Interface** | `uart_if.sv` | Defines all signals with clocking blocks for driver and monitor |
| **Transaction** | `uart_transaction.sv` | Holds randomized `dintx` data with constraint (1–50) |
| **Generator** | `uart_generator.sv` | Randomizes transactions and sends to driver via mailbox |
| **Driver** | `uart_driver.sv` | Drives `dintx` and `newd` signals to DUT via interface |
| **Monitor** | `uart_monitor.sv` | Monitors TX serial stream and RX parallel output |
| **Scoreboard** | `uart_scoreboard.sv` | Compares transmitted vs received data, reports pass/fail |
| **Environment** | `uart_environment.sv` | Connects generator, driver, monitor, scoreboard via mailboxes |
| **Base Test** | `base_test.sv` | Top-level test; creates environment and runs N transactions |
| **Package** | `sim_files_pkg.sv` | Packages all TB files and defines baud/clock parameters |
| **TB Top** | `tb_top.sv` | Instantiates DUT + interface, drives clock/reset, runs test |

---

## Parameters

| Parameter | Default Value | Description |
|---|---|---|
| `clk_freq` | 1,000,000 Hz | Clock frequency |
| `baud_rate` | 9600 | UART baud rate |
| `baud_clk` | 104 cycles | Clock cycles per bit |

---

## How to Run

### Using ModelSim / Questa

```bash
cd UART/simulation
vsim -do run.do
```

The `run.do` script compiles and runs the simulation:

```tcl
vlog ../rtl/uart_top.sv ../rtl/uart_if.sv ../testbench/sim_files_pkg.sv ../testbench/tb_top.sv
vsim -c work.tb_top
run 500ns
```

### Changing Number of Transactions

In `tb_top.sv`, modify the transaction count:

```systemverilog
test_h = new("BASE_TEST", u_inf, 10);  // Change 10 to desired count
```

---

## Testbench Flow

```
Generator
   │  (mailbox: gen2drv)
   ▼
Driver ──────────────► DUT (uart_top)
   │  (mailbox: drv2scb)         │
   │                             │
   ▼                             ▼
Scoreboard ◄────────── Monitor
           (mailbox: mon2scb)
```

---

## Results

- The scoreboard compares `dintx` (transmitted) vs `doutrx` (received)
- Pass/Fail count is reported at the end of simulation
- Supports full-duplex loopback: `rx` is connected to `tx` in the DUT

---

## Tools Required

- ModelSim / Questa Sim
- SystemVerilog support (IEEE 1800)
