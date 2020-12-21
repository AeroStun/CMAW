# Copyright 2020 AeroStun <_as@aerostun.dev>
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

list (APPEND TESTCASES Version Cache Config Sketch Core Board Library Preprocess)

macro (cmaw_run_testsuite)
  cmake_policy (SET CMP0011 NEW)
  
  get_filename_component (SCRIPT_DIR "${CMAKE_SCRIPT_MODE_FILE}" DIRECTORY)
  get_filename_component (PARENT_DIR ${SCRIPT_DIR} DIRECTORY)
  list (APPEND CMAKE_MODULE_PATH "${PARENT_DIR}")
  list (APPEND CMAKE_MODULE_PATH "${SCRIPT_DIR}")
  list (APPEND CMAKE_MODULE_PATH "${SCRIPT_DIR}/utils")

  set (TESTBENCH_ARDUINOCLI_VERSION "$ENV{ARDUINOCLI_VER}")
  message ("Running testbench with CMake ${CMAKE_VERSION} and ArduinoCLI ${TESTBENCH_ARDUINOCLI_VERSION}")

  set (TESTBENCH_TMPDIR "${SCRIPT_DIR}/.run")
  file (MAKE_DIRECTORY "${TESTBENCH_TMPDIR}")
  
  include (Colours)
  include (Sleep)

  include (CMAW)

  list (LENGTH TESTCASES COUNT_CASES)

  set (COUNT_PASSED 0)
  foreach (TESTCASE ${TESTCASES})
    set (TEST_PASS FALSE)
    message ("Running test \"${TESTCASE}\"")
    include (${TESTCASE})
    if (TEST_PASS)
      math (EXPR COUNT_PASSED "${COUNT_PASSED} + 1")
      message ("${Green}Passed test \"${TESTCASE}\"${ColourReset}")
    else ()
      message ("${Red}Failed test \"${TESTCASE}\"${ColourReset}")
    endif ()
  endforeach ()

  file (REMOVE_RECURSE "${TESTBENCH_TMPDIR}")
  
  message ("\nSummary: ${COUNT_PASSED}/${COUNT_CASES} tests passed")
  if (COUNT_PASSED EQUAL COUNT_CASES)
    message ("Testsuite ${BoldGreen}PASSED${ColourReset}")
  else ()
    message ("Testsuite ${BoldRed}FAILED${ColourReset}")
    message (FATAL_ERROR "")
  endif()
endmacro()

cmaw_run_testsuite ()
