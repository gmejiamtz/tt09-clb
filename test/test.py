# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles


@cocotb.test()
async def test_a_not_async(dut):
    seed = 0b01010101
    print(dir(dut))
    dut._log.info("Start Test: not A (Async)")
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
    dut._log.info("LUT3 Seeding")
    dut.uio_in.value = seed
    dut.ui_in.value = 0b00001000
    await ClockCycles(dut.clk,1)
    dut.ui_in.value = 0b00000000
    await ClockCycles(dut.clk,1)
    assert dut.uut.lut.lookup_table_r.value == seed
    input_value = 0
    while(input_value != 8):
        dut.ui_in.value = input_value
        a_value = input_value & 0b00000001
        await ClockCycles(dut.clk,1)
        dut._log.info(f"not A:{bin(a_value)}")
        assert dut.uo_out.value == (~a_value & 0b00000001)
        input_value += 1
    dut._log.info("Test Over")


@cocotb.test()
async def test_a_b_and_async(dut):
    seed = 0b10001000
    print(dir(dut))
    dut._log.info("Start Test: A and B (Async)")
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
    dut._log.info("LUT3 Seeding")
    dut.uio_in.value = seed
    dut.ui_in.value = 0b00001000
    await ClockCycles(dut.clk,1)
    dut.ui_in.value = 0b00000000
    await ClockCycles(dut.clk,1)
    assert dut.uut.lut.lookup_table_r.value == seed
    input_value = 0
    while(input_value != 8):
        dut.ui_in.value = input_value
        a_value = input_value & 0b00000001
        b_value = (input_value & 0b00000010) >> 1
        await ClockCycles(dut.clk,1)
        dut._log.info(f"A:{bin(a_value)} and B:{bin(b_value)}")
        assert dut.uo_out.value == ((a_value & b_value) & 0b00000001)
        input_value += 1
    dut._log.info("Test Over")


@cocotb.test()
async def test_a_b_or_async(dut):
    seed = 0b11101110
    print(dir(dut))
    dut._log.info("Start Test: A or B (Async)")
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
    dut._log.info("LUT3 Seeding")
    dut.uio_in.value = seed
    dut.ui_in.value = 0b00001000
    await ClockCycles(dut.clk,1)
    dut.ui_in.value = 0b00000000
    await ClockCycles(dut.clk,1)
    assert dut.uut.lut.lookup_table_r.value == seed
    input_value = 0
    while(input_value != 8):
        dut.ui_in.value = input_value
        a_value = input_value & 0b00000001
        b_value = (input_value & 0b00000010) >> 1
        await ClockCycles(dut.clk,1)
        dut._log.info(f"A:{bin(a_value)} or B:{bin(b_value)}")
        assert dut.uo_out.value == ((a_value | b_value) & 0b00000001)
        input_value += 1
    dut._log.info("Test Over")

@cocotb.test()
async def test_a_b_xor_async(dut):
    seed = 0b01100110
    print(dir(dut))
    dut._log.info("Start Test: A xor B (Async)")
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
    dut._log.info("LUT3 Seeding")
    dut.uio_in.value = seed
    dut.ui_in.value = 0b00001000
    await ClockCycles(dut.clk,1)
    dut.ui_in.value = 0b00000000
    await ClockCycles(dut.clk,1)
    assert dut.uut.lut.lookup_table_r.value == seed
    input_value = 0
    while(input_value != 8):
        dut.ui_in.value = input_value
        a_value = input_value & 0b00000001
        b_value = (input_value & 0b00000010) >> 1
        await ClockCycles(dut.clk,1)
        dut._log.info(f"A:{bin(a_value)} xor B:{bin(b_value)}")
        assert dut.uo_out.value == ((a_value ^ b_value) & 0b00000001)
        input_value += 1
    dut._log.info("Test Over")

@cocotb.test()
async def test_a_b_nand_async(dut):
    seed = 0b01110111
    print(dir(dut))
    dut._log.info("Start Test: A nand B (Async)")
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
    dut._log.info("LUT3 Seeding")
    dut.uio_in.value = seed
    dut.ui_in.value = 0b00001000
    await ClockCycles(dut.clk,1)
    dut.ui_in.value = 0b00000000
    await ClockCycles(dut.clk,1)
    assert dut.uut.lut.lookup_table_r.value == seed
    input_value = 0
    while(input_value != 8):
        dut.ui_in.value = input_value
        a_value = input_value & 0b00000001
        b_value = (input_value & 0b00000010) >> 1
        await ClockCycles(dut.clk,1)
        dut._log.info(f"A:{bin(a_value)} nand B:{bin(b_value)}")
        assert dut.uo_out.value == (~(a_value & b_value) & 0b00000001)
        input_value += 1
    dut._log.info("Test Over")

@cocotb.test()
async def test_a_b_nor_async(dut):
    seed = 0b00010001
    print(dir(dut))
    dut._log.info("Start Test: A nor B (Async)")
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
    dut._log.info("LUT3 Seeding")
    dut.uio_in.value = seed
    dut.ui_in.value = 0b00001000
    await ClockCycles(dut.clk,1)
    dut.ui_in.value = 0b00000000
    await ClockCycles(dut.clk,1)
    assert dut.uut.lut.lookup_table_r.value == seed
    input_value = 0
    while(input_value != 8):
        dut.ui_in.value = input_value
        a_value = input_value & 0b00000001
        b_value = (input_value & 0b00000010) >> 1
        await ClockCycles(dut.clk,1)
        dut._log.info(f"A:{bin(a_value)} nor B:{bin(b_value)}")
        assert dut.uo_out.value == (~(a_value | b_value) & 0b00000001)
        input_value += 1
    dut._log.info("Test Over")

@cocotb.test()
async def test_a_b_c_nand_async(dut):
    seed = 0b01111111
    print(dir(dut))
    dut._log.info("Start Test: A nand B nand C (Async)")
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
    dut._log.info("LUT3 Seeding")
    dut.uio_in.value = seed
    dut.ui_in.value = 0b00001000
    await ClockCycles(dut.clk,1)
    dut.ui_in.value = 0b00000000
    await ClockCycles(dut.clk,1)
    assert dut.uut.lut.lookup_table_r.value == seed
    input_value = 0
    while(input_value != 8):
        dut.ui_in.value = input_value
        a_value = input_value & 0b00000001
        b_value = (input_value & 0b00000010) >> 1
        c_value = (input_value & 0b00000100) >> 2
        await ClockCycles(dut.clk,1)
        dut._log.info(f"A:{bin(a_value)} nand B:{bin(b_value)} nand C:{bin(c_value)}")
        assert dut.uo_out.value == (~(a_value & b_value & c_value) & 0b00000001)
        input_value += 1
    dut._log.info("Test Over")

@cocotb.test()
async def test_a_b_c_nor_async(dut):
    seed = 0b00000001
    print(dir(dut))
    dut._log.info("Start Test: A nor B nor C (Async)")
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
    dut._log.info("LUT3 Seeding")
    dut.uio_in.value = seed
    dut.ui_in.value = 0b00001000
    await ClockCycles(dut.clk,1)
    dut.ui_in.value = 0b00000000
    await ClockCycles(dut.clk,1)
    assert dut.uut.lut.lookup_table_r.value == seed
    input_value = 0
    while(input_value != 8):
        dut.ui_in.value = input_value
        a_value = input_value & 0b00000001
        b_value = (input_value & 0b00000010) >> 1
        c_value = (input_value & 0b00000100) >> 2
        await ClockCycles(dut.clk,1)
        dut._log.info(f"A:{bin(a_value)} nor B:{bin(b_value)} nor C:{bin(c_value)}")
        assert dut.uo_out.value == (~(a_value | b_value | c_value) & 0b00000001)
        input_value += 1
    dut._log.info("Test Over")