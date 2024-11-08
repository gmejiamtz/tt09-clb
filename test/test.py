# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles


@cocotb.test()
async def test_project(dut):

    print(dir(dut))
    dut._log.info("Start")
    # Set the clock period to 10 us (100 KHz)
    clock = Clock(dut.clk, 10, units="ns")
    cocotb.start_soon(clock.start())
    # Reset
    dut._log.info("Reset")
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1
    dut._log.info("Initialization of SDRAM")
    await ClockCycles(dut.clk, 10)
    while(dut.uut.controller.state.value == 1):
        await ClockCycles(dut.clk, 1)
        print(f"Mircoseconds counter at {dut.uut.controller.hundred_micro_sec_counter_value.value.integer}.")
    assert dut.uut.controller.state.value == 2 #must be in idle state
    dut._log.info("Mode Programming of SDRAM Done, idling for 5 cycles")
    await ClockCycles(dut.clk,5)
    #start a read at col 0 and row 0, bank 0
    dut.ui_in.value = 0b00000100
    await ClockCycles(dut.clk,2)
    assert dut.uut.controller.state.value == 3 #must be in active state
    dut.ui_in.value = 0b00000000  #deassert read start
    while(dut.uut.controller.state.value  == 3):
        await ClockCycles(dut.clk, 1)
        print(f"Active_to_RW counter at {dut.uut.controller.active_to_rw_counter_value.value.integer}.")
    assert dut.uut.controller.state.value == 6 #must be in read state
    assert not(dut.uut.read_valid.value) #read should not be valid yet
    while(dut.uut.controller.cas_counter_value.value != 3):
        await ClockCycles(dut.clk, 1)
        print(f"CAS counter at {dut.uut.controller.cas_counter_value.value.integer}.")
    assert dut.uut.read_valid.value #read should not be valid yet
    await ClockCycles(dut.clk, 1)
    assert dut.uut.controller.state.value == 2 #must be in idle state
