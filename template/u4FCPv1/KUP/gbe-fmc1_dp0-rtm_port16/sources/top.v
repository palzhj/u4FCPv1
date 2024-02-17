`timescale 1ps/1ps
/*******************************************************************************
* System      : u4FCP GbE readout                                           *
* Version     : v 1.1 2024/02/12                                               *
*                                                                              *
* Description : Top Module                                                     *
*                                                                              *
* Designer    : zhj@ihep.ac.cn                                                 *
*                                                                              *
*******************************************************************************/
module top #(
  parameter         USE_CHIPSCOPE = 1,
  parameter [31:0]  SYN_DATE      = 32'h0, // the date of compiling
  parameter [7:0]   FPGA_VER      = 8'h1,         // the code version
  parameter [4 :0]  PHY_ADDRESS   = 5'b1
)(
  input             CLK_IN_200_P,
  input             CLK_IN_200_N,
// I/O
  input             RST_B,
  output            RLED_B,
  output            GLED_B,
  output            BLED_B,
// FMC0
  // input             FMC0_DP_M2C_P0,
  // input             FMC0_DP_M2C_N0,
  // output            FMC0_DP_C2M_P0,
  // output            FMC0_DP_C2M_N0,
// FMC1
  input             FMC1_DP_M2C_P0,
  input             FMC1_DP_M2C_N0,
  output            FMC1_DP_C2M_P0,
  output            FMC1_DP_C2M_N0,
// RTM
  output            AMC2RTM_P16,
  output            AMC2RTM_N16,
  input             RTM2AMC_P16,
  input             RTM2AMC_N16,
  input             RTM_PS_B
);

////////////////////////////////////////////////////////////////////////////////
//  Clock
wire clk200_in, clk200_int;
IBUFDS #(
  .DIFF_TERM    ("TRUE")
) IBUFDS_clk200 (
  .O            (clk200_in),
  .I            (CLK_IN_200_P),
  .IB           (CLK_IN_200_N)
);
BUFG BUFG_200 (
  .O            (clk200_int),
  .I            (clk200_in)
);

wire clk40_int, clk100_int, clk125_int, locked;
clk_wiz clk_wiz(
  // Clock in ports
  .clk_in1      (clk200_int),
  // Clock out ports
  .clk_out1     (clk40_int),
  .clk_out2     (clk100_int),
  .clk_out3     (clk125_int),
  // Status and control signals
  .resetn       (RST_B),
  .locked       (locked)
);

// An IDELAYCTRL primitive needs to be instantiated for the Fixed Tap Delay mode of the IDELAY.
wire dlyctrl_rdy;
IDELAYCTRL #(
  .SIM_DEVICE ("ULTRASCALE")  // Set the device version for simulation functionality (ULTRASCALE)
)
IDELAYCTRL_inst (
  .RDY        (dlyctrl_rdy),  // 1-bit output: Ready output
  .REFCLK     (clk200_int),   // 1-bit input: Reference clock input
  .RST        (~RST_B)        // 1-bit input: Active-High reset input. Asynchronous assert, synchronous deassert to REFCLK.
);

////////////////////////////////////////////////////////////////////////////////
// System clock and reset
wire usrclk, rst;
assign usrclk = clk125_int;

async2sync_reset reset_usrclk(
  .rst_in       (~(locked & dlyctrl_rdy)),
  .clk          (usrclk),
  .rst_out      (rst)
);

wire  [7 : 0] gmii_tx_d_a, gmii_tx_d_b;       // Transmit data from client MAC.
wire          gmii_tx_en_a, gmii_tx_en_b;     // Transmit control signal from client MAC.
wire          gmii_tx_er_a, gmii_tx_er_b;     // Transmit control signal from client MAC.
wire  [7 : 0] gmii_rx_d_a, gmii_rx_d_b;       // Received Data to client MAC.
wire          gmii_rx_dv_a, gmii_rx_dv_b;     // Received control signal to client MAC.
wire          gmii_rx_er_a, gmii_rx_er_b;     // Received control signal to client MAC.
wire mdc, mdio, mdio_complete;

//---------------------------------------------------------------------------
// Instantiate GT Interface
//---------------------------------------------------------------------------
wire        userclk2_a;
wire        eth_rst_done_a;
wire [15:0] status_vector_a;
gig_ethernet_pcs_pma_support_gth gig_ethernet_pcs_pma_gth_i(
  // Transceiver Interface
  .gtgrefclk              (usrclk),
  .txp                    (FMC1_DP_C2M_P0),
  .txn                    (FMC1_DP_C2M_N0),
  .rxp                    (FMC1_DP_M2C_P0),
  .rxn                    (FMC1_DP_M2C_N0),
  .mmcm_locked_out        (),
  .userclk_out            (),         // 62.5 MHz
  .userclk2_out           (userclk2_a), // 125 MHz
  .rxuserclk_out          (),         // 62.5 MHz
  .rxuserclk2_out         (),         // 62.5 MHz
  .independent_clock_bufg (clk40_int),
  .pma_reset_out          (),
  .resetdone              (eth_rst_done_a),
  // GMII Interface
  .gmii_txd               (gmii_tx_d_a),
  .gmii_tx_en             (gmii_tx_en_a),
  .gmii_tx_er             (gmii_tx_er_a),
  .gmii_rxd               (gmii_rx_d_a),
  .gmii_rx_dv             (gmii_rx_dv_a),
  .gmii_rx_er             (gmii_rx_er_a),
  .gmii_isolate           (),
  // Management: MDIO Interface
  .mdc                    (mdc),
  .mdio_i                 (mdio),
  .mdio_o                 (),
  .mdio_t                 (),
  .phyaddr                (PHY_ADDRESS),
  .configuration_vector   (5'b10000),
  .configuration_valid    (1'b0),
  // General IO's
  .status_vector          (status_vector_a),
  .reset                  (rst),
  .signal_detect          (1'b1)
  );

//---------------------------------------------------------------------------
// Instantiate GT Interface
//---------------------------------------------------------------------------
wire        userclk2_b;
wire        eth_rst_done_b;
wire [15:0] status_vector_b;
gig_ethernet_pcs_pma_support_gty gig_ethernet_pcs_pma_gty_i(
  // Transceiver Interface
  .gtgrefclk              (usrclk),
  .txp                    (AMC2RTM_P16),
  .txn                    (AMC2RTM_N16),
  .rxp                    (RTM2AMC_P16),
  .rxn                    (RTM2AMC_N16),
  .mmcm_locked_out        (),
  .userclk_out            (),         // 62.5 MHz
  .userclk2_out           (userclk2_b), // 125 MHz
  .rxuserclk_out          (),         // 62.5 MHz
  .rxuserclk2_out         (),         // 62.5 MHz
  .independent_clock_bufg (clk40_int),
  .pma_reset_out          (),
  .resetdone              (eth_rst_done_b),
  // GMII Interface
  .gmii_txd               (gmii_tx_d_b),
  .gmii_tx_en             (gmii_tx_en_b),
  .gmii_tx_er             (gmii_tx_er_b),
  .gmii_rxd               (gmii_rx_d_b),
  .gmii_rx_dv             (gmii_rx_dv_b),
  .gmii_rx_er             (gmii_rx_er_b),
  .gmii_isolate           (),
  // Management: MDIO Interface
  .mdc                    (mdc),
  .mdio_i                 (mdio),
  .mdio_o                 (),
  .mdio_t                 (),
  .phyaddr                (PHY_ADDRESS),
  .configuration_vector   (5'b10000),
  .configuration_valid    (1'b0),
  // General IO's
  .status_vector          (status_vector_b),
  .reset                  (rst),
  .signal_detect          (1'b1)
  );

mdio_init mdio_init_i(
  .clk                    (usrclk),         // in : system clock (125M)
  .rst                    (~(eth_rst_done_a & eth_rst_done_b)),  // in : system reset
  .phyaddr                (PHY_ADDRESS),    // in : [4:0] PHY address
  .mdc                    (mdc),       // out: clock (1/128 system clock)
  .mdio_out               (mdio),      // out: connect this to "PCS/PMA + RocketIO" module .mdio?_i()
  .complete               (mdio_complete)   // out: initializing sequence has completed (active H)
);

reg gmii_rx_dv_a_r;
always @(posedge userclk2_a) gmii_rx_dv_a_r <= gmii_rx_dv_a;
wire wr_en_a = gmii_rx_dv_a_r | gmii_rx_dv_a;
wire empty_a;

fifo10 fifo10_a(
  .rst        (rst),
  .wr_clk     (userclk2_a),
  .wr_en      (wr_en_a),
  .din        ({gmii_rx_er_a, gmii_rx_dv_a, gmii_rx_d_a}),
  .full       (),
  .rd_clk     (userclk2_b),
  .rd_en      (~empty_a),
  .dout       ({gmii_tx_er_b, gmii_tx_en_b, gmii_tx_d_b}),
  .empty      (empty_a),
  .wr_rst_busy(),
  .rd_rst_busy()
);

reg gmii_rx_dv_b_r;
always @(posedge userclk2_b) gmii_rx_dv_b_r <= gmii_rx_dv_b;
wire wr_en_b = gmii_rx_dv_b_r | gmii_rx_dv_b;
wire empty_b;

fifo10 fifo10_b(
  .rst        (rst),
  .wr_clk     (userclk2_b),
  .wr_en      (wr_en_b),
  .din        ({gmii_rx_er_b, gmii_rx_dv_b, gmii_rx_d_b}),
  .full       (),
  .rd_clk     (userclk2_a),
  .rd_en      (~empty_b),
  .dout       ({gmii_tx_er_a, gmii_tx_en_a, gmii_tx_d_a}),
  .empty      (empty_b),
  .wr_rst_busy(),
  .rd_rst_busy()
);

//////////////////////////////////////////////////////////////////////////////
assign BLED_B = eth_rst_done_a;
assign GLED_B = eth_rst_done_b;
assign RLED_B = mdio_complete;

endmodule
