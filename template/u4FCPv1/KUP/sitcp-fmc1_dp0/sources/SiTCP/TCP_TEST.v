//----------------------------------------------------------------------//
//
//  Copyright (c) 2020 BeeBeans Technologies All rights reserved
//
//    Description : SiTCP(1GbE SiTCP) test bench
//
//    history :
//      The original source was developed by Dr. Uchida(2018/02/23)
//      20200923  Ver 1.1   --------- Created by BBT
//      20240226  Ver 2.0   --------- Modify to adopt GbE by Jie
//
//----------------------------------------------------------------------//
module tcp_test(
  // System
  input         CLK,                // Tx clock
  input         RST,                // System reset
  input  [3 :0] TX_RATE,            // Transmission data rate in units of 100 Mbps
  input  [63:0] NUM_OF_DATA,        // Number of bytes of transmitted data
  input         DATA_GEN,           // Data transmission enable
  input         LOOPBACK,           // Loopback mode
  input  [2 :0] WORD_LEN,           // Unused, Word length of test data
  input         SELECT_SEQ,         // Sequence Data select
  input  [31:0] SEQ_PATTERN,        // sequence data (The default value is 0x60808040)
  input  [23:0] BLK_SIZE,           // Transmission block size in bytes
  input         INS_ERROR,          // Data error insertion
  // TCP port
  input          TCP_OPEN,
  output [15:0]  TCP_RX_WC,
  input          TCP_RX_WR,
  input  [7 :0]  TCP_RX_DATA,
  input          TCP_TX_FULL,
  output         TCP_TX_WR,
  output [7 :0]  TCP_TX_DATA
);

reg   [ 3:0]  irTxRate;
reg   [64:0]  irNumOfData;
reg           irDataGen;
reg           irLoopback;
reg   [24:0]  irBlockSize;
reg           irInsError;
reg           irEstablished;
reg           irTxAlmostFull;

wire          TxEnable;
reg           genEnb;
reg   [24:0]  BlockCount;
reg   [64:0]  TxCount;
reg   [ 4:0]  RateCount;
reg   [ 4:0]  AddToken;
reg   [31:0]  Bucket;
reg           genCntCy;
reg   [ 7:0]  genCntr;
reg   [ 7:0]  muxTxD;
reg           muxTxWR;
reg   [ 7:0]  orTxD;
reg           orTxWR;

//------------------------------------------------------------------------------
//  Input buffer
//------------------------------------------------------------------------------
always @(posedge CLK) begin
  irTxRate        <= TX_RATE;
  irNumOfData     <= {1'b1,NUM_OF_DATA[63:0]} - 65'd1;
  irDataGen       <= DATA_GEN;
  irLoopback      <= LOOPBACK;
  irBlockSize     <= {1'b1,BLK_SIZE[23:0]} - 25'd1;
  irEstablished   <= TCP_OPEN;
  irTxAlmostFull  <= TCP_TX_FULL;
end

always @(posedge CLK) begin
  if(RST) irInsError <= 1'b0;
  else
    if(INS_ERROR) irInsError <= 1'b1;
    else
      if (TxEnable) irInsError <= 1'b0;
      else irInsError <= irInsError;
end

//------------------------------------------------------------------------------
//  Controller
//------------------------------------------------------------------------------
assign TCP_RX_WC[15:0] = 16'b1111_0000_0000_0000;

//
//  RateCount[4:0]  16,7,...,15,16 : 1count/10clock(@125MHz) = 12.5MByte/sec = 100Mbps
//
assign  TxEnable  = genEnb & BlockCount[24] & TxCount[64];

always @(posedge CLK) begin
  genEnb            <= irEstablished & ~irTxAlmostFull & irDataGen;
  BlockCount[24:0]  <= (irEstablished & (Bucket[31]|BlockCount[24]))? (BlockCount[24:0] - {21'd0,(TxEnable? 4'b1: 4'd0)}):  irBlockSize[24:0];
  if(!(irEstablished&irDataGen))begin
    TxCount[64:0]   <= irNumOfData[64:0];
    RateCount[4:0]  <= 5'd0;
    AddToken[4:0]   <= 5'd0;
    Bucket[31:0]    <= 32'd0;
  end
  else begin
    TxCount[64:0]   <= TxCount[64:0] - {64'd0,(TxEnable?  1'b1:  1'b0)};
    RateCount[4:0]  <= RateCount[4:0] - (RateCount[4]?  5'd9: 5'b1_1111);
    AddToken[4:0]   <= {1'b0,((RateCount[4] & (Bucket[31:30] != 2'b01))?  irTxRate[3:0]: 4'd0)} - {4'd0,(TxEnable? 1'b1: 1'd0)};
    Bucket[31:0]    <= Bucket[31:0] + {{28{AddToken[4]}}, AddToken[3:0]};
  end
end

always @(posedge CLK) begin
  if(!irEstablished) begin
    genCntCy  <= 1'b0;
    genCntr   <= 8'd1;
  end
  else
    if(TxEnable) {genCntCy,genCntr[7:0]}<= {1'b0,genCntr[7:0]} + 9'b1 + {8'b0, genCntCy};
end

always @(posedge CLK) begin
  muxTxWR <= TxEnable;
  if(TxEnable) muxTxD <= (genCntr[7:0] + (genCntCy? 8'd1: 8'd0)) ^ (irInsError? 8'd1: 8'd0);
end

always @(posedge CLK) begin
  orTxD  <= irLoopback? TCP_RX_DATA : muxTxD;
  orTxWR <= irLoopback? TCP_RX_WR : muxTxWR;
end

assign  TCP_TX_DATA[7:0] = orTxD[7:0];
assign  TCP_TX_WR        = orTxWR;

//------------------------------------------------------------------------------
endmodule
