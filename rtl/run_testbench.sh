#!/bin/bash

# Run testbench on given hex file, full hex file name as input

set -eou pipefail

TESTCASE="$1"
TEST_DIRECTORY="../test"

TESTNAME=$(basename ${TESTCASE} .hex.txt)
INSTR=$(echo $TESTNAME | cut -d'_' -f 5)
NUM=$(echo $TESTNAME | cut -d'_' -f 6)
CODE="${INSTR}_${NUM}"
# Redirect output to stder (&2) so that it seperate from genuine outputs
# Using ${VARIANT} substitutes in the value of the variable VARIANT
iverilog -g 2012 \
   mips_cpu_*.v mips_cpu_definitions.vh ${TEST_DIRECTORY}/test_mips_cpu_bus_generic.v  \
   -s  mips_cpu_bus_tb \
   -P mips_cpu_bus_tb.RAM_INIT_FILE=\"${TEST_DIRECTORY}/1-hex/${TESTCASE}\" \
   -P mips_cpu_bus_tb.TESTCASE_ID=\"${CODE}\" \
   -P mips_cpu_bus_tb.INSTRUCTION=\"${INSTR}\" \
   -o ${TEST_DIRECTORY}/2-simulator/${TESTNAME}

${TEST_DIRECTORY}/2-simulator/${TESTNAME}
