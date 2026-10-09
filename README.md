# FPGA labs on Basys 3: VHDL, MicroBlaze, custom AXI-Lite IP

Three guided labs on a Digilent Basys 3 (Xilinx Artix-7 XC7A35T), Master 1 SESI, Sorbonne Université (UE MU4IN108, 2025-2026): synthesis-aware VHDL, a MicroBlaze system with bare-metal C, and a custom AXI4-Lite peripheral.

| Folder | What I did | Tools |
| --- | --- | --- |
| [`tp1-vhdl-synthesis`](tp1-vhdl-synthesis) | Fixed dead logic, button-as-clock and inferred latches in a counter + decoder + FSM design | VHDL, Vivado simulation and synthesis |
| [`tp2-microblaze-gpio`](tp2-microblaze-gpio) | MicroBlaze + AXI GPIO block design, three bare-metal C programs | Vivado IP Integrator, Vitis, C |
| [`tp3-axi-lite-ip`](tp3-axi-lite-ip) | Designed, packaged and integrated the `my_led` AXI4-Lite IP, driven from C | VHDL, Vivado IP packager, Vitis, C |

## Tools

| Tool | Use |
| --- | --- |
| Vivado 2020.2 | Simulation, synthesis, RTL schematics, IP Integrator, IP packager |
| Vitis | BSP generation, C application, debugger |
| Basys 3 (Artix-7 XC7A35T) | Target board, 100 MHz clock |

## Flow

VHDL modules (TP1) → MicroBlaze system with GPIO and C (TP2) → same system with a custom AXI4-Lite IP replacing the GPIO (TP3).

## Credits

The course provided the exercises and project skeletons; the corrected VHDL, the C programs, the IP and the analysis are mine. Course statements and reports are not included.

Licensed under MIT.
