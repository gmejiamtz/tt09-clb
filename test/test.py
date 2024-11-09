# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles

@cocotb.test()
async def main_test(dut):
    print(dir(dut))
    seeds = {"not": 0b01010101, "and2": 0b10001000, "or2": 0b11101110, "xor2": 0b01100110, "nand2": 0b01110111, "nor2": 0b00010001, "nand3": 0b01111111, "nor3": 0b00000001,
            "majority": 0b11101000}
    # Set the clock period to 10 us (100 KHz)
    clock = Clock(dut.clk, 10, units="us")
    cocotb.start_soon(clock.start())
    # Reset
    dut._log.info("Reset")
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1
    await test_a_not_async(dut,seeds["not"])
    await test_a_b_and_async(dut,seeds["and2"])
    await test_a_b_or_async(dut,seeds["or2"])
    await test_a_b_xor_async(dut,seeds["xor2"])
    await test_a_b_nand_async(dut,seeds["nand2"])
    await test_a_b_nor_async(dut, seeds["nor2"])
    await test_a_b_c_nand_async(dut,seeds["nand3"])
    await test_a_b_c_nor_async(dut,seeds["nor3"])
    await test_a_b_c_majority_async(dut,seeds["majority"])
    dut._log.info("All Tests Completed Successfully!")

async def test_a_not_async(dut,seed):
    dut._log.info("Start Test: not A (Async)")
    dut.uio_in.value = seed
    dut.ui_in.value = 0b00001000
    await ClockCycles(dut.clk,1)
    dut.ui_in.value = 0b00000000
    await ClockCycles(dut.clk,1)
    input_value = 0
    while(input_value != 8):
        dut.ui_in.value = input_value
        a_value = input_value & 0b00000001
        await ClockCycles(dut.clk,1)
        dut._log.info(f"A:{bin(a_value)} Out:{dut.uut.uo_out.value}")
        assert dut.uo_out.value == (~a_value & 0b00000001)
        input_value += 1
    await ClockCycles(dut.clk,2)


async def test_a_b_and_async(dut,seed):
    dut._log.info("Start Test: A and B (Async)")
    dut.uio_in.value = seed
    dut.ui_in.value = 0b00001000
    await ClockCycles(dut.clk,1)
    dut.ui_in.value = 0b00000000
    await ClockCycles(dut.clk,1)
    input_value = 0
    while(input_value != 8):
        dut.ui_in.value = input_value
        a_value = input_value & 0b00000001
        b_value = (input_value & 0b00000010) >> 1
        await ClockCycles(dut.clk,1)
        dut._log.info(f"A:{bin(a_value)} B:{bin(b_value)} Out:{dut.uut.uo_out.value}")
        assert dut.uo_out.value == ((a_value & b_value) & 0b00000001)
        input_value += 1
    await ClockCycles(dut.clk,2)

async def test_a_b_or_async(dut, seed):
    dut._log.info("Start Test: A or B (Async)")
    dut.uio_in.value = seed
    dut.ui_in.value = 0b00001000
    await ClockCycles(dut.clk,1)
    dut.ui_in.value = 0b00000000
    await ClockCycles(dut.clk,1)
    input_value = 0
    while(input_value != 8):
        dut.ui_in.value = input_value
        a_value = input_value & 0b00000001
        b_value = (input_value & 0b00000010) >> 1
        await ClockCycles(dut.clk,1)
        dut._log.info(f"A:{bin(a_value)} B:{bin(b_value)} Out:{dut.uut.uo_out.value}")
        assert dut.uo_out.value == ((a_value | b_value) & 0b00000001)
        input_value += 1
    await ClockCycles(dut.clk,2)

async def test_a_b_xor_async(dut,seed):
    dut._log.info("Start Test: A xor B (Async)")
    dut.uio_in.value = seed
    dut.ui_in.value = 0b00001000
    await ClockCycles(dut.clk,1)
    dut.ui_in.value = 0b00000000
    await ClockCycles(dut.clk,1)
    input_value = 0
    while(input_value != 8):
        dut.ui_in.value = input_value
        a_value = input_value & 0b00000001
        b_value = (input_value & 0b00000010) >> 1
        await ClockCycles(dut.clk,1)
        dut._log.info(f"A:{bin(a_value)} B:{bin(b_value)} Out:{dut.uut.uo_out.value}")
        assert dut.uo_out.value == ((a_value ^ b_value) & 0b00000001)
        input_value += 1
    await ClockCycles(dut.clk,2)

async def test_a_b_nand_async(dut,seed):
    dut._log.info("Start Test: A nand B (Async)")
    dut.uio_in.value = seed
    dut.ui_in.value = 0b00001000
    await ClockCycles(dut.clk,1)
    dut.ui_in.value = 0b00000000
    await ClockCycles(dut.clk,1)
    input_value = 0
    while(input_value != 8):
        dut.ui_in.value = input_value
        a_value = input_value & 0b00000001
        b_value = (input_value & 0b00000010) >> 1
        await ClockCycles(dut.clk,1)
        dut._log.info(f"A:{bin(a_value)} B:{bin(b_value)} Out:{dut.uut.uo_out.value}")
        assert dut.uo_out.value == (~(a_value & b_value) & 0b00000001)
        input_value += 1
    await ClockCycles(dut.clk,1)

async def test_a_b_nor_async(dut,seed):
    dut._log.info("Start Test: A nor B (Async)")
    dut.uio_in.value = seed
    dut.ui_in.value = 0b00001000
    await ClockCycles(dut.clk,1)
    dut.ui_in.value = 0b00000000
    await ClockCycles(dut.clk,1)
    input_value = 0
    while(input_value != 8):
        dut.ui_in.value = input_value
        a_value = input_value & 0b00000001
        b_value = (input_value & 0b00000010) >> 1
        await ClockCycles(dut.clk,1)
        dut._log.info(f"A:{bin(a_value)} B:{bin(b_value)} Out:{dut.uut.uo_out.value}")
        assert dut.uo_out.value == (~(a_value | b_value) & 0b00000001)
        input_value += 1
    await ClockCycles(dut.clk,1)

async def test_a_b_c_nand_async(dut,seed):
    dut._log.info("Start Test: A nand B nand C (Async)")
    dut.uio_in.value = seed
    dut.ui_in.value = 0b00001000
    await ClockCycles(dut.clk,1)
    dut.ui_in.value = 0b00000000
    await ClockCycles(dut.clk,1)
    input_value = 0
    while(input_value != 8):
        dut.ui_in.value = input_value
        a_value = input_value & 0b00000001
        b_value = (input_value & 0b00000010) >> 1
        c_value = (input_value & 0b00000100) >> 2
        await ClockCycles(dut.clk,1)
        dut._log.info(f"A:{bin(a_value)} B:{bin(b_value)} C:{bin(c_value)} Out:{dut.uut.uo_out.value}")
        assert dut.uo_out.value == (~(a_value & b_value & c_value) & 0b00000001)
        input_value += 1
    await ClockCycles(dut.clk,1)

async def test_a_b_c_nor_async(dut,seed):
    dut._log.info("Start Test: A nor B nor C (Async)")
    dut.uio_in.value = seed
    dut.ui_in.value = 0b00001000
    await ClockCycles(dut.clk,1)
    dut.ui_in.value = 0b00000000
    await ClockCycles(dut.clk,1)
    input_value = 0
    while(input_value != 8):
        dut.ui_in.value = input_value
        a_value = input_value & 0b00000001
        b_value = (input_value & 0b00000010) >> 1
        c_value = (input_value & 0b00000100) >> 2
        await ClockCycles(dut.clk,1)
        dut._log.info(f"A:{bin(a_value)} B:{bin(b_value)} C:{bin(c_value)} Out:{dut.uut.uo_out.value}")
        assert dut.uo_out.value == (~(a_value | b_value | c_value) & 0b00000001)
        input_value += 1
    await ClockCycles(dut.clk,1)

async def test_a_b_c_majority_async(dut,seed):
    dut._log.info("Start Test: 3 Bit Majority (Async)")
    dut.uio_in.value = seed
    dut.ui_in.value = 0b00001000
    await ClockCycles(dut.clk,1)
    dut.ui_in.value = 0b00000000
    await ClockCycles(dut.clk,1)
    input_value = 0
    while(input_value != 8):
        dut.ui_in.value = input_value
        a_value = input_value & 0b00000001
        b_value = (input_value & 0b00000010) >> 1
        c_value = (input_value & 0b00000100) >> 2
        await ClockCycles(dut.clk,1)
        dut._log.info(f"A:{bin(a_value)} B:{bin(b_value)} C:{bin(c_value)} Out:{dut.uut.uo_out.value}")
        assert dut.uo_out.value == (((a_value & b_value) | (c_value & (a_value | b_value)) ) & 0b00000001)
        input_value += 1
    await ClockCycles(dut.clk,1)