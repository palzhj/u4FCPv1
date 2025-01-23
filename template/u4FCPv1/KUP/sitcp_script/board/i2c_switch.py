#!/usr/bin/python
# This is i2c_switch.py file
# author: zhj@ihep.ac.cn
# 2024-04-01 created
import lib
from lib import i2c

GPIO_PIN_0  = 0x01
GPIO_PIN_1  = 0x02
GPIO_PIN_2  = 0x04
GPIO_PIN_3  = 0x08
GPIO_PIN_4  = 0x10
GPIO_PIN_5  = 0x20
GPIO_PIN_6  = 0x40
GPIO_PIN_7  = 0x80

DDR1_PIN      = GPIO_PIN_7
DDR0_PIN      = GPIO_PIN_6
FMC1_PIN      = GPIO_PIN_5
FMC0_PIN      = GPIO_PIN_4
RTM_PIN       = GPIO_PIN_3
CLK_PIN       = GPIO_PIN_2
FPGA_PIN      = GPIO_PIN_1
PMBUS_PIN     = GPIO_PIN_0

class i2c_switch(object):
  """Class for communicating with an I2C switch using TCA9548."""
  def __init__(self, i2c_addr = 0b1110_0000, base_address = 0x00020000, clk_freq = 125, i2c_freq = 100):
    self.i2c = i2c.i2c(device_address = i2c_addr, base_address = base_address,
                   clk_freq = clk_freq, i2c_freq = i2c_freq)

  def get_status(self):
    temp = self.i2c.read8()
    print("I2C   \tDDR1\tDDR0\tFMC1\tFMC0\tRTM\tCLK\tFPGA\tPMBUS")
    print("Switch\t%d  \t%d  \t%d  \t%d  \t%d \t%d \t%d  \t%d"%(\
      1 if temp&DDR1_PIN else 0, 1 if temp&DDR0_PIN else 0,
      1 if temp&FMC1_PIN else 0, 1 if temp&FMC0_PIN else 0,
      1 if temp&RTM_PIN  else 0, 1 if temp&CLK_PIN  else 0, 
      1 if temp&FPGA_PIN else 0, 1 if temp&PMBUS_PIN else 0))

  def enable_ddr1(self):
    temp = self.i2c.read8()
    self.i2c.write8(temp|DDR1_PIN)

  def enable_ddr0(self):
    temp = self.i2c.read8()
    self.i2c.write8(temp|DDR0_PIN)

  def enable_fmc1(self):
    temp = self.i2c.read8()
    self.i2c.write8(temp|FMC1_PIN)

  def enable_fmc0(self):
    temp = self.i2c.read8()
    self.i2c.write8(temp|FMC0_PIN)

  def enable_rtm(self):
    temp = self.i2c.read8()
    self.i2c.write8(temp|RTM_PIN)

  def enable_clk(self):
    temp = self.i2c.read8()
    self.i2c.write8(temp|CLK_PIN)

  def enable_fpga(self):
    temp = self.i2c.read8()
    self.i2c.write8(temp|FPGA_PIN)

  def enable_pmbus(self):
    temp = self.i2c.read8()
    self.i2c.write8(temp|PMBUS_PIN)

  def disable_ddr1(self):
    temp = self.i2c.read8()
    self.i2c.write8(temp&~DDR1_PIN)

  def disable_ddr0(self):
    temp = self.i2c.read8()
    self.i2c.write8(temp&~DDR0_PIN)

  def disable_fmc1(self):
    temp = self.i2c.read8()
    self.i2c.write8(temp&~FMC1_PIN)

  def disable_fmc0(self):
    temp = self.i2c.read8()
    self.i2c.write8(temp&~FMC0_PIN)

  def disable_rtm(self):
    temp = self.i2c.read8()
    self.i2c.write8(temp&~RTM_PIN)

  def disable_clk(self):
    temp = self.i2c.read8()
    self.i2c.write8(temp&~CLK_PIN)

  def disable_fpga(self):
    temp = self.i2c.read8()
    self.i2c.write8(temp&~FPGA_PIN)

  def disable_pmbus(self):
    temp = self.i2c.read8()
    self.i2c.write8(temp&~PMBUS_PIN)



