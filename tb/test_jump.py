import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, FallingEdge, Timer
import random

async def start_clock(clk_pin):
    clk_pin.value = 0
    await Timer(5, "ns")
    cocotb.start_soon(Clock(clk_pin, 1, units="ns").start())

async def reset_dut(dut):
    """ Reset the DUT """
    await FallingEdge(dut.i_clk)
    dut.i_rst.value = 0
    for n in range(2):
        await RisingEdge(dut.i_clk)
    dut.i_rst.value = 1

@cocotb.test()
async def test_jump(dut):
    cnt = 1000
    """ Assign Initial to Input """
    dut.i_rst.value = 1
    dut.rs1_val.value = 0
    dut.pc_prev.value = 0
    dut.imm.value = 0
    dut.jump_control.value = 0

    """ Start Clock and Give Reset """
    await start_clock(dut.i_clk)
    await reset_dut(dut)

    """ TESTCASE """
    jmp_ctrl = 0
    pc_prev = 0
    rs1 = 0
    imm = 0
    for n in range(cnt):
        """ Assign Values to Input """

        print(f"\nTest Case {n}: pc_prev={pc_prev} jump_control={jmp_ctrl} rs1={rs1} imm={imm}")

        await Timer(0.1,units="ns")

        clk=0

        if jmp_ctrl > 0:
            if jmp_ctrl == 1:
                print("\tJAL")
                pc_update_val = (pc_prev + imm)
            else:
                print("\tJALR")
                pc_update_val = (rs1 + imm)

            print(f"\tClock {clk} -- Expected : pc_update_control={1} pc_update_val={pc_update_val} rd_write_control={1} rd_write_val={(pc_prev+4)} ignore_curr_inst={0}")
            print(f"\t           Sim      : pc_update_control={dut.pc_update_control.value.integer} pc_update_val={dut.pc_update_val.value.integer} rd_write_control={dut.rd_write_control.value.integer} rd_write_val={dut.rd_write_val.value.integer} ignore_curr_inst={dut.ignore_curr_inst.value.integer}")

            assert 0 == dut.ignore_curr_inst.value.integer
            assert 1 == dut.rd_write_control.value.integer
            assert (pc_prev+4) == dut.rd_write_val.value.integer
            assert pc_update_val == dut.pc_update_val.value.integer
            assert 1 == dut.pc_update_control.value.integer

            await RisingEdge(dut.i_clk)
            dut.pc_prev.value = pc_prev + 4
            dut.rs1_val.value = 0
            dut.imm.value = 0
            dut.jump_control.value = 0
            await Timer(0.1,units="ns")

            print(f"\tClock {clk+1} -- Expected : pc_update_control={0} pc_update_val={0} rd_write_control={0} rd_write_val={0} ignore_curr_inst={1}")
            print(f"\t           Sim      : pc_update_control={dut.pc_update_control.value.integer} pc_update_val={dut.pc_update_val.value.integer} rd_write_control={dut.rd_write_control.value.integer} rd_write_val={dut.rd_write_val.value.integer} ignore_curr_inst={dut.ignore_curr_inst.value.integer}")

            assert 1 == dut.ignore_curr_inst.value.integer
            assert 0 == dut.rd_write_control.value.integer
            assert 0 == dut.rd_write_val.value.integer
            assert 0 == dut.pc_update_val.value.integer
            assert 0 == dut.pc_update_control.value.integer

            clk+=2
        else:
            print(f"\tJUMP_NOP")

        await RisingEdge(dut.i_clk)
        await Timer(0.1,units="ns")
        print(f"\tClock {clk} -- Expected : pc_update_control={0} pc_update_val={0} rd_write_control={0} rd_write_val={0} ignore_curr_inst={0}")
        print(f"\t           Sim      : pc_update_control={dut.pc_update_control.value.integer} pc_update_val={dut.pc_update_val.value.integer} rd_write_control={dut.rd_write_control.value.integer} rd_write_val={dut.rd_write_val.value.integer} ignore_curr_inst={dut.ignore_curr_inst.value.integer}")
        
        assert 0 == dut.ignore_curr_inst.value.integer
        assert 0 == dut.rd_write_control.value.integer
        assert 0 == dut.rd_write_val.value.integer
        assert 0 == dut.pc_update_val.value.integer
        assert 0 == dut.pc_update_control.value.integer

        jmp_ctrl = random.randrange(0, 3)
        pc_prev = 4*random.randrange(0, 2**28)
        rs1 = random.randrange(0, 2**30)
        imm = random.randrange(0, 2**12)

        dut.pc_prev.value = pc_prev
        dut.rs1_val.value = rs1
        dut.imm.value = imm
        dut.jump_control.value = jmp_ctrl
