function (test_board)
  function (test_board_listall)
    cmaw_list_known_boards (NAMES FQBNS)
    
    list (LENGTH NAMES NAMES_COUNT)
    list (LENGTH FQBNS FQBNS_COUNT)
    
    if (NOT (NAMES_COUNT AND FQBNS_COUNT))
      set (LISTALL_TEST_PASS FALSE PARENT_SCOPE)
      message ("Failed subtest \"listall\" (1)")
      return ()
    endif ()
    
    if (NAMES_COUNT EQUAL FQBNS_COUNT)
      set (LISTALL_TEST_PASS TRUE PARENT_SCOPE)
    else ()
      set (LISTALL_TEST_PASS FALSE PARENT_SCOPE)
      message ("Failed subtest \"listall\" (2)")
    endif ()
  endfunction ()
  
  function (test_board_list)
    if (TESTSUITE_MANUAL)
      string (ASCII 7 BEL)
      
      cmaw_list_connected_boards (PORTS TYPES EVENTS NAMES FQBNS CORES)
      if(PORTS OR TYPES OR EVENTS OR NAMES OR FQBNS OR CORES)
        set (LIST_TEST_PASS FALSE PARENT_SCOPE)
        message ("Failed subtest \"list\" (1)")
        return ()
      endif ()
      
      message ("${BEL} You have 5 seconds to connect a board")
      sleep (5)
      message ("${BEL} Time is up!")
      
      cmaw_list_connected_boards (PORTS TYPES EVENTS NAMES FQBNS CORES)
      
      if(NOT (PORTS AND TYPES AND EVENTS AND NAMES AND FQBNS AND CORES))
        set (LIST_TEST_PASS FALSE PARENT_SCOPE)
        message ("Failed subtest \"list\" (2)")
        return ()
      endif ()
      
      message ("${BEL} You have 5 seconds to disconnect the board")
      sleep (5)
      message ("${BEL} Time is up!")
      
      cmaw_list_connected_boards (PORTS TYPES EVENTS NAMES FQBNS CORES)
      
      if(PORTS OR TYPES OR EVENTS OR NAMES OR FQBNS OR CORES)
        set (LIST_TEST_PASS FALSE PARENT_SCOPE)
        message ("Failed subtest \"list\" (3)")
      else ()
        set (LIST_TEST_PASS TRUE PARENT_SCOPE)
      endif ()
    else () # CI obviously cannot connect an arduino board on a serial port
      set (LIST_TEST_PASS TRUE PARENT_SCOPE)
    endif ()
  endfunction ()
  
  test_board_listall ()
  test_board_list ()
  
  if (LISTALL_TEST_PASS AND LIST_TEST_PASS)
    set (TEST_PASS TRUE PARENT_SCOPE)
  else ()
    set (TEST_PASS FALSE PARENT_SCOPE)
  endif ()
endfunction ()

test_board ()
