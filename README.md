# uFCPv1 & RTM_M2

## Introduction

MicroTCA.4 Fast Control and Process board (u4FCP) is an FPGA-based [MicroTCA.4](https://www.picmg.org/product/microtca-enhancements-rear-io-precision-timing-specification/) compatible Advanced Mezzanine Card (AMC) targeting generic clock, control and data acquisition in High-Energy Physics(HEP) experiments. 

Rear Transition Module with M.2 (RTM_M2) is a rear transition module in the rear of the crate to have four M.2 sockets and increase the I/O capability of the u4FCP. The u4FCP and RTM_M2 are connected through fabric connectors in the upper area above the standard µTCA backplane area, defined as Zone 3. The pin assignment is compatible with the [Zone 3 recommendation](https://techlab.desy.de/resources/zone_3_recommendation/index_eng.html) D1.4 for digital applications.

u4FCP & RTM_M2 are conceived to serve a mid-sized system residing either inside a MicroTCA crate or stand-alone on desktop with high-speed optical links to PC.

The I/O capability of u4FCP & RTM_M2 can be further enhanced with four [VITA-57.1 FPGA Mezzanine Cards (FMC)](https://ohwr.org/projects/fmc-projects/wiki/fmc-standard) through the high-pin-count sockets. 

:memo: **Note:** Either of these two boards can be used independently bench-top prototyping.

:warning: **Warning:** The u4FCP and RTM_M2 board can be damaged by electrostatic discharge (ESD). Follow standard ESD prevention measures when handling the board.

## Board Specifications

### Dimensions

#### u4FCP

* Height: 180.6 mm 
* Length: 148.5 mm

#### RTM_M2

* Height: 182.5 mm 
* Length: 148.5 mm

### Environmental Temperature

* Operating: 0°C to +45°C 
* Storage: -25°C to +60°C

### Humidity

* 10% to 90% non-condensing

### Operating Voltage

* +12 VDC

<figure>
    <img src="/readme/photo.png"
    	width="800"
        alt="Board Pictures">
    <figcaption><em>Photo of u4FCP & RTM_M2</em></figcaption>
</figure>

## System Architecture

A block diagram of the u4FCP and RTM_M2 is shown below. The red lines are high-speed serial links connected to the [gigabyte transceivers (GTY/GTH/GTX)](https://docs.xilinx.com/r/en-US/ug440-xilinx-power-estimator/Using-the-Transceiver-Sheets-GTP-GTX-GTH-GTY-GTZ) of the FPGA. The blue lines are the general input/outputs connected to the High Performance (HP), High Range (HR) or High Density (HD) banks of the FPGA. 

<figure>
    <img src="/readme/block_diagram.png"
    	width="800"
        alt="Block Giagram">
    <figcaption><em>Block diagram of u4FCP & RTM_M2</em></figcaption>
</figure>

### FMC connection

Although the FMC standard defines LA, HA, HB and DP differential ports, only parts of them are connected to FPGA duo to limited IO resources.
The table below summarizes the connections of FMC

<table cellspacing="0" border="0">
    <colgroup></colgroup>
    <colgroup></colgroup>
    <colgroup></colgroup>
    <colgroup span="2"></colgroup>
    <colgroup></colgroup>
    <colgroup></colgroup>
    <colgroup></colgroup>
    <colgroup></colgroup>
    <tr>
        <td rowspan=3 align="center" valign=middle>FMC</td>
        <td colspan=8 align="center" valign=middle>HPC</td>
        </tr>
    <tr>
        <td colspan=3 align="center" valign=middle>LPC</td>
        <td align="left" valign=middle><br></td>
        <td align="left" valign=middle><br></td>
        <td align="left" valign=middle><br></td>
        <td align="left" valign=middle><br></td>
        <td align="left" valign=middle><br></td>
    </tr>
    <tr>
        <td align="left" valign=middle>LA[16:0]</td>
        <td align="left" valign=middle>LA[33:17]</td>
        <td align="left" valign=middle>DP[0]</td>
        <td align="left" valign=middle>DP[9:1]</td>
        <td align="left" valign=middle>HA[16:0]</td>
        <td align="left" valign=middle>HA[23:17]</td>
        <td align="left" valign=middle>HB[16:0]</td>
        <td align="left" valign=middle>HB[21:17]</td>
    </tr>
    <tr>
        <td align="left" valign=middle>AMC FMC0</td>
        <td align="left" valign=middle>HP bank 1.8V</td>
        <td align="left" valign=middle>-</td>
        <td align="left" valign=middle>1 GTY</td>
        <td align="left" valign=middle>7 GTY</td>
        <td align="left" valign=middle>-</td>
        <td align="left" valign=middle>-</td>
        <td align="left" valign=middle>-</td>
        <td align="left" valign=middle>-</td>
    </tr>
    <tr>
        <td align="left" valign=middle>AMC FMC1</td>
        <td align="left" valign=middle>HP bank 1.8V</td>
        <td align="left" valign=middle>-</td>
        <td align="left" valign=middle>1 GTH</td>
        <td align="left" valign=middle>7 GTH</td>
        <td align="left" valign=middle>-</td>
        <td align="left" valign=middle>-</td>
        <td align="left" valign=middle>-</td>
        <td align="left" valign=middle>-</td>
    </tr>
    <tr>
        <td align="left" valign=middle>RTM FMC0</td>
        <td align="left" valign=middle>HR bank 2.5V or 3.3V</td>
        <td align="left" valign=middle>HR bank 2.5V or 3.3V</td>
        <td align="left" valign=middle>1 GTX</td>
        <td align="left" valign=middle>7 GTX</td>
        <td align="left" valign=middle>-</td>
        <td align="left" valign=middle>-</td>
        <td align="left" valign=middle>-</td>
        <td align="left" valign=middle>-</td>
    </tr>
    <tr>
        <td align="left" valign=middle>RTM FMC1</td>
        <td align="left" valign=middle>HR bank 2.5V or 3.3V</td>
        <td align="left" valign=middle>HR bank 2.5V or 3.3V</td>
        <td align="left" valign=middle>1 GTX</td>
        <td align="left" valign=middle>3 GTX</td>
        <td align="left" valign=middle>-</td>
        <td align="left" valign=middle>-</td>
        <td align="left" valign=middle>-</td>
        <td align="left" valign=middle>-</td>
    </tr>
</table>

### JTAG Configuration

Users can access to the FPGA through the MicroTCA crate or JTAG header. A configurable logic circuit acts as a bridge selecting the JTAG master source between the JTAG header and AMC/RTM JTAG lines. When an FMC card is attached to u4FCP & RTM_M2, the circuit automatically adds the attached device to the JTAG chain as determined by its FMC_PRSNT_M2C_B signal. It's recommended to implement a TDI to TDO connection via a device or bypass jumper for the JTAG chain to be completed on the attached FMC card. If not, the circuit can be configured by software to bypass the JTAG chain of FMC.

<figure>
    <img src="/readme/jtag.png"
    	width="600"
        alt="JTAG programming connections">
    <figcaption><em>JTAG programming connections</em></figcaption>
</figure>

## u4FCP

Built around the Xilinx Kintex UltraScale+ FPGA, u4FCP provides users with a platform with synchronous clock, trigger/control, high volume data memory and high bandwidth data throughput that are required in general experiment. 

<figure>
    <img src="/readme/block_diagram_u4fcp.png"
    	width="400"
        alt="FPGA Block Giagram of u4FCP">
    <figcaption><em>FPGA Block diagram of u4FCP</em></figcaption>
</figure>

An on-board microcontroller, which the host can communicate with either via IPMB Bus of the chassis backplane or through the USB/UART port on the front panel, is responsible for power-on initialization, parameter monitoring, e.g. voltages/currents or temperature, and also hot-plug capability, activation state display, payload power management and communication with the [MicroTCA Carrier Hub (MCH)](https://www.picmg.org/spec-product-category/microtca_mch), etc. The firmware of the microcontroller is developed based on real-time operating system, [FreeRTOS](https://freertos.org), and migrated from [CERN-MMC](https://espace.cern.ch/ph-dep-ESE-BE-uTCAEvaluationProject/MMC_project/default.aspx) to support ARM Cortex-M3. More information can be found [here](https://iopscience.iop.org/article/10.1088/1748-0221/16/03/T03005).

The following figure shows the gigabyte transceiver connection on u4FCP.

<figure>
    <img src="/readme/GT_Quads.png"
    	width="800"
        alt="GT connection on u4FCP">
    <figcaption><em>Connections for 52 GTY/GTH transceivers (5 GTY quads and 8 GTH quads)

1. FMC HPC connector (8 GTY)
2. FMC HPC connector (8 GTH)
3. AMC ports (16 GTH)
4. RTM ports (12 GTY and 8 GTH )
</em></figcaption>
</figure>

:warning: **Warning:** Other than RTM[19:16] (GTY131), every other GT Quad is in reverse order for PCIe connection (For instance, [3:0]=>[0:3]).

On-board memories are summarized below:

1. Two up to 16G-Byte DDR4 SODIMM with 72-bit data bus
2. 1M-bit I2C Serial EEPROM for MMC
3. 256M-bit Quad SPI Flash for storing the FPGA firmware

## RTM_M2

We design the RTM_M2 with four M.2 sockets to support NVMe SSD and use FPGA (Xilinx Kintex-7) to extended low speed interface.

<figure>
    <img src="/readme/block_diagram_rtm_m2.png"
    	width="400"
        alt="FPGA Block Giagram of RTM_M2">
    <figcaption><em>FPGA Block diagram of RTM_M2</em></figcaption>
</figure>

2 GTX quads connect to RTM FMC0, 1 GTX quad to RTM FMC1, and the last quad to RTM[19:16] to communicate with the u4FCP.

<figure>
    <img src="/readme/GTX_Quads.png"
    	width="200"
        alt="GTX connection on RTM_M2">
    <figcaption><em>Connections for 16 GTX transceivers</em></figcaption>
</figure>

On-board memories are summarized below:

1. 512M x 64 bit DDR3L
2. 2K-bit I2C Serial EEPROM with EUI-48™ Identity, providing a unique node Ethernet MAC address for mass-production process
3. 256M-bit Quad SPI Flash for storing the FPGA firmware
4. 