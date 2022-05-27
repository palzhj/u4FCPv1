# uFCPv1 & RTM_M2

## Introduction

MicroTCA.4 Fast Control and Process board (u4FCP) is an FPGA-based [MicroTCA.4](https://www.picmg.org/product/microtca-enhancements-rear-io-precision-timing-specification/) compatible Advanced Mezzanine Card (AMC) targeting generic clock, control and data acquisition in High-Energy Physics(HEP) experiments. 

Rear Transition Module with M.2 (RTM_M2) is a rear transition module in the rear of the crate to have four M.2 sockets and increase the I/O capability of the u4FCP. The u4FCP and RTM_M2 are connected through fabric connectors in the upper area above the standard µTCA backplane area, defined as Zone 3. The pin assignment is compatible with the [Zone 3 recommendation](https://techlab.desy.de/resources/zone_3_recommendation/index_eng.html) D1.4 for digital applications.

u4FCP & RTM_M2 are conceived to serve a mid-sized system residing either inside a MicroTCA crate or stand-alone on desktop with high-speed optical links or Ethernet to PC.

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
        <td align="left" valign=middle>1 GTY</td>
        <td align="left" valign=middle>7 GTY</td>
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