function (test_version)
  cmaw_arduinocli_version (ARDCLI_VER)

  if (ARDCLI_VER VERSION_EQUAL TESTBENCH_ARDUINOCLI_VERSION)
    set (TEST_PASS TRUE PARENT_SCOPE)
  else ()
    message ("Expected ${TESTBENCH_ARDUINOCLI_VERSION} but found ${ARDCLI_VER}")
    set (TEST_PASS FALSE PARENT_SCOPE)
  endif ()
endfunction ()

test_version ()
