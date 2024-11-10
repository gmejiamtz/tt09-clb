# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles

@cocotb.test()
async def main_test(dut):
    print(dir(dut))
    seeds = {"not": 0b01010101, "and2": 0b10001000, "or2": 0b11101110, "xor2": 0b01100110, "nand2": 0b01110111, "nor2": 0b00010001, "nand3": 0b01111111, "nor3": 0b00000001,
            "majority": 0b11101000, "even_parity": 0b01101001,"one_hot":0b00010110}
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
    await test_a_not(dut,seeds["not"])
    await test_a_b_and(dut,seeds["and2"])
    await test_a_b_or(dut,seeds["or2"])
    await test_a_b_xor(dut,seeds["xor2"])
    await test_a_b_nand(dut,seeds["nand2"])
    await test_a_b_nor(dut, seeds["nor2"])
    await test_a_b_c_nand(dut,seeds["nand3"])
    await test_a_b_c_nor(dut,seeds["nor3"])
    await test_a_b_c_majority(dut,seeds["majority"])
    await test_a_b_c_even_parity(dut,seeds["even_parity"])
    await test_a_b_c_one_hot(dut,seeds["one_hot"])
    await test_a_not(dut,seeds["not"],True)
    await test_a_b_and(dut,seeds["and2"],True)
    await test_a_b_or(dut,seeds["or2"],True)
    await test_a_b_xor(dut,seeds["xor2"],True)
    await test_a_b_nand(dut,seeds["nand2"],True)
    await test_a_b_nor(dut, seeds["nor2"],True)
    await test_a_b_c_nand(dut,seeds["nand3"],True)
    await test_a_b_c_nor(dut,seeds["nor3"],True)
    await test_a_b_c_majority(dut,seeds["majority"],True)
    await test_a_b_c_even_parity(dut,seeds["even_parity"],True)
    await test_a_b_c_one_hot(dut,seeds["one_hot"],True)
    dut._log.info("All Tests Completed Successfully!")

async def test_a_not(dut,seed, sync=False):
    dut._log.info(f"Start Test: not A | Is Sync:{sync}")
    dut.uio_in.value = seed
    sync_mask = int(sync) << 4
    sync_cycles = 2 if sync else 1
    dut.ui_in.value = 0b00001000 | sync_mask
    await ClockCycles(dut.clk,1)
    dut.ui_in.value = 0b00000000 | sync_mask
    await ClockCycles(dut.clk,1)
    input_value = 0
    while(input_value != 8):
        dut.ui_in.value = input_value | sync_mask
        a_value = input_value & 0b00000001
        await ClockCycles(dut.clk,sync_cycles)
        dut._log.info(f"A:{bin(a_value)} Out:{dut.uut.uo_out.value}")
        assert dut.uo_out.value == (~a_value & 0b00000001)
        input_value += 1
    await ClockCycles(dut.clk,2)

async def test_a_b_and(dut,seed,sync=False):
    dut._log.info(f"Start Test: A and B | Is Sync:{sync}")
    dut.uio_in.value = seed
    sync_mask = int(sync) << 4
    sync_cycles = 2 if sync else 1
    dut.ui_in.value = 0b00001000 | sync_mask
    await ClockCycles(dut.clk,1)
    dut.ui_in.value = 0b00000000 | sync_mask
    await ClockCycles(dut.clk,1)
    input_value = 0
    while(input_value != 8):
        dut.ui_in.value = input_value | sync_mask
        a_value = input_value & 0b00000001
        b_value = (input_value & 0b00000010) >> 1
        await ClockCycles(dut.clk,sync_cycles)
        dut._log.info(f"A:{bin(a_value)} B:{bin(b_value)} Out:{dut.uut.uo_out.value}")
        assert dut.uo_out.value == ((a_value & b_value) & 0b00000001)
        input_value += 1
    await ClockCycles(dut.clk,2)

async def test_a_b_or(dut, seed,sync=False):
    dut._log.info(f"Start Test: A or B | Is Sync:{sync}")
    dut.uio_in.value = seed
    sync_mask = int(sync) << 4
    sync_cycles = 2 if sync else 1
    dut.ui_in.value = 0b00001000 | sync_mask
    await ClockCycles(dut.clk,1)
    dut.ui_in.value = 0b00000000 | sync_mask
    await ClockCycles(dut.clk,1)
    input_value = 0
    while(input_value != 8):
        dut.ui_in.value = input_value | sync_mask
        a_value = input_value & 0b00000001
        b_value = (input_value & 0b00000010) >> 1
        await ClockCycles(dut.clk,sync_cycles)
        dut._log.info(f"A:{bin(a_value)} B:{bin(b_value)} Out:{dut.uut.uo_out.value}")
        assert dut.uo_out.value == ((a_value | b_value) & 0b00000001)
        input_value += 1
    await ClockCycles(dut.clk,2)

async def test_a_b_xor(dut,seed,sync=False):
    dut._log.info(f"Start Test: A xor B | Is Sync:{sync}")
    dut.uio_in.value = seed
    sync_mask = int(sync) << 4
    sync_cycles = 2 if sync else 1
    dut.ui_in.value = 0b00001000 | sync_mask
    await ClockCycles(dut.clk,1)
    dut.ui_in.value = 0b00000000 | sync_mask
    await ClockCycles(dut.clk,1)
    input_value = 0
    while(input_value != 8):
        dut.ui_in.value = input_value | sync_mask
        a_value = input_value & 0b00000001
        b_value = (input_value & 0b00000010) >> 1
        await ClockCycles(dut.clk,sync_cycles)
        dut._log.info(f"A:{bin(a_value)} B:{bin(b_value)} Out:{dut.uut.uo_out.value}")
        assert dut.uo_out.value == ((a_value ^ b_value) & 0b00000001)
        input_value += 1
    await ClockCycles(dut.clk,2)

async def test_a_b_nand(dut,seed,sync=False):
    dut._log.info(f"Start Test: A nand B | Is Sync:{sync}")
    dut.uio_in.value = seed
    sync_mask = int(sync) << 4
    sync_cycles = 2 if sync else 1
    dut.ui_in.value = 0b00001000 | sync_mask
    await ClockCycles(dut.clk,1)
    dut.ui_in.value = 0b00000000 | sync_mask
    await ClockCycles(dut.clk,1)
    input_value = 0
    while(input_value != 8):
        dut.ui_in.value = input_value | sync_mask
        a_value = input_value & 0b00000001
        b_value = (input_value & 0b00000010) >> 1
        await ClockCycles(dut.clk,sync_cycles)
        dut._log.info(f"A:{bin(a_value)} B:{bin(b_value)} Out:{dut.uut.uo_out.value}")
        assert dut.uo_out.value == (~(a_value & b_value) & 0b00000001)
        input_value += 1
    await ClockCycles(dut.clk,1)

async def test_a_b_nor(dut,seed,sync=False):
    dut._log.info(f"Start Test: A nor B | Is Sync:{sync}")
    dut.uio_in.value = seed
    sync_mask = int(sync) << 4
    sync_cycles = 2 if sync else 1
    dut.ui_in.value = 0b00001000 | sync_mask
    await ClockCycles(dut.clk,1)
    dut.ui_in.value = 0b00000000 | sync_mask
    await ClockCycles(dut.clk,1)
    input_value = 0
    while(input_value != 8):
        dut.ui_in.value = input_value | sync_mask
        a_value = input_value & 0b00000001
        b_value = (input_value & 0b00000010) >> 1
        await ClockCycles(dut.clk,sync_cycles)
        dut._log.info(f"A:{bin(a_value)} B:{bin(b_value)} Out:{dut.uut.uo_out.value}")
        assert dut.uo_out.value == (~(a_value | b_value) & 0b00000001)
        input_value += 1
    await ClockCycles(dut.clk,1)

async def test_a_b_c_nand(dut,seed,sync=False):
    dut._log.info(f"Start Test: A nand B nand C | Is Sync:{sync}")
    dut.uio_in.value = seed
    sync_mask = int(sync) << 4
    sync_cycles = 2 if sync else 1
    dut.ui_in.value = 0b00001000 | sync_mask
    await ClockCycles(dut.clk,1)
    dut.ui_in.value = 0b00000000 | sync_mask
    await ClockCycles(dut.clk,1)
    input_value = 0
    while(input_value != 8):
        dut.ui_in.value = input_value | sync_mask
        a_value = input_value & 0b00000001
        b_value = (input_value & 0b00000010) >> 1
        c_value = (input_value & 0b00000100) >> 2
        await ClockCycles(dut.clk,sync_cycles)
        dut._log.info(f"A:{bin(a_value)} B:{bin(b_value)} C:{bin(c_value)} Out:{dut.uut.uo_out.value}")
        assert dut.uo_out.value == (~(a_value & b_value & c_value) & 0b00000001)
        input_value += 1
    await ClockCycles(dut.clk,1)

async def test_a_b_c_nor(dut,seed,sync=False):
    dut._log.info(f"Start Test: A nor B nor C | Is Sync:{sync}")
    dut.uio_in.value = seed
    sync_mask = int(sync) << 4
    sync_cycles = 2 if sync else 1
    dut.ui_in.value = 0b00001000 | sync_mask
    await ClockCycles(dut.clk,1)
    dut.ui_in.value = 0b00000000 | sync_mask
    await ClockCycles(dut.clk,1)
    input_value = 0
    while(input_value != 8):
        dut.ui_in.value = input_value | sync_mask
        a_value = input_value & 0b00000001
        b_value = (input_value & 0b00000010) >> 1
        c_value = (input_value & 0b00000100) >> 2
        await ClockCycles(dut.clk,sync_cycles)
        dut._log.info(f"A:{bin(a_value)} B:{bin(b_value)} C:{bin(c_value)} Out:{dut.uut.uo_out.value}")
        assert dut.uo_out.value == (~(a_value | b_value | c_value) & 0b00000001)
        input_value += 1
    await ClockCycles(dut.clk,1)

async def test_a_b_c_majority(dut,seed,sync=False):
    dut._log.info(f"Start Test: 3 Bit Majority | Is Sync:{sync}")
    dut.uio_in.value = seed
    sync_mask = int(sync) << 4
    sync_cycles = 2 if sync else 1
    dut.ui_in.value = 0b00001000 | sync_mask
    await ClockCycles(dut.clk,1)
    dut.ui_in.value = 0b00000000 | sync_mask
    await ClockCycles(dut.clk,1)
    input_value = 0
    while(input_value != 8):
        dut.ui_in.value = input_value | sync_mask
        a_value = input_value & 0b00000001
        b_value = (input_value & 0b00000010) >> 1
        c_value = (input_value & 0b00000100) >> 2
        await ClockCycles(dut.clk,sync_cycles)
        dut._log.info(f"A:{bin(a_value)} B:{bin(b_value)} C:{bin(c_value)} Out:{dut.uut.uo_out.value}")
        assert dut.uo_out.value == (((a_value & b_value) | (c_value & (a_value | b_value)) ) & 0b00000001)
        input_value += 1
    await ClockCycles(dut.clk,1)

async def test_a_b_c_even_parity(dut,seed,sync=False):
    dut._log.info(f"Start Test: 3 Bit Even Parity | Is Sync:{sync}")
    dut.uio_in.value = seed
    sync_mask = int(sync) << 4
    sync_cycles = 2 if sync else 1
    dut.ui_in.value = 0b00001000 | sync_mask
    await ClockCycles(dut.clk,1)
    dut.ui_in.value = 0b00000000 | sync_mask
    await ClockCycles(dut.clk,1)
    input_value = 0
    while(input_value != 8):
        dut.ui_in.value = input_value | sync_mask
        a_value = input_value & 0b00000001
        b_value = (input_value & 0b00000010) >> 1
        c_value = (input_value & 0b00000100) >> 2
        await ClockCycles(dut.clk,sync_cycles)
        dut._log.info(f"A:{bin(a_value)} B:{bin(b_value)} C:{bin(c_value)} Out:{dut.uut.uo_out.value}")
        assert dut.uo_out.value == (~(a_value ^ b_value ^ c_value) & 0b00000001)
        input_value += 1
    await ClockCycles(dut.clk,1)

async def test_a_b_c_one_hot(dut,seed,sync=False):
    dut._log.info(f"Start Test: 3 Bit One Hot Detector | Is Sync:{sync}")
    dut.uio_in.value = seed
    sync_mask = int(sync) << 4
    sync_cycles = 2 if sync else 1
    dut.ui_in.value = 0b00001000 | sync_mask
    await ClockCycles(dut.clk,1)
    dut.ui_in.value = 0b00000000 | sync_mask
    await ClockCycles(dut.clk,1)
    input_value = 0
    while(input_value != 8):
        dut.ui_in.value = input_value | sync_mask
        a_value = input_value & 0b00000001
        b_value = (input_value & 0b00000010) >> 1
        c_value = (input_value & 0b00000100) >> 2
        await ClockCycles(dut.clk,sync_cycles)
        dut._log.info(f"A:{bin(a_value)} B:{bin(b_value)} C:{bin(c_value)} Out:{dut.uut.uo_out.value}")
        assert dut.uo_out.value == (((a_value & ~b_value & ~c_value) | (~a_value & b_value & ~c_value) | (~a_value & ~b_value & c_value)) & 0b00000001)
        input_value += 1
    await ClockCycles(dut.clk,1)
