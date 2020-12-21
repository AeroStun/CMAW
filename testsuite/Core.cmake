function (test_core)
  function (test_core_index)
    cmaw_update_core_index ()
    set (INDEX_TEST_PASS TRUE PARENT_SCOPE)
  endfunction ()
  
  function (test_core_list)
    cmaw_list_installed_cores (IDS VERSIONS LATESTS NAMES)
    
    list (FIND IDS "arduino:avr" ARDAVR_INDEX)
    if (ARDAVR_INDEX EQUAL -1)
      set (LIST_TEST_PASS FALSE PARENT_SCOPE)
      message ("Failed subtest \"list\" (1)")
      return ()
    endif ()
    
    list (GET NAMES ${ARDAVR_INDEX} ARDAVR_NAME)
    
    if (ARDAVR_NAME STREQUAL "Arduino AVR Boards")
      set (LIST_TEST_PASS TRUE PARENT_SCOPE)
    else ()
      set (LIST_TEST_PASS FALSE PARENT_SCOPE)
      message ("Failed subtest \"list\" (2)")
    endif ()
  endfunction ()

  function (test_core_install)
    cmaw_install_cores ("arduino:avr" "arduino:samd@1.6.6")
    
    cmaw_list_installed_cores (IDS VERSIONS LATESTS NAMES)
    
    list (FIND IDS "arduino:samd" ARDSAMD_INDEX)
    if (ARDSAMD_INDEX EQUAL -1)
      set (INST_TEST_PASS FALSE PARENT_SCOPE)
      message ("Failed subtest \"install\" (1)")
      return ()
    endif ()
    
    list (GET NAMES ${ARDSAMD_INDEX} ARDSAMD_NAME)
    list (GET VERSIONS ${ARDSAMD_INDEX} ARDSAMD_VER)
    
    if (ARDSAMD_VER VERSION_EQUAL "1.6.6")
      set (INST_TEST_PASS TRUE PARENT_SCOPE)
    else ()
      set (INST_TEST_PASS FALSE)
      message ("Failed subtest \"install\" (2)")
      return ()
    endif ()
    
    if (ARDSAMD_NAME STREQUAL "Arduino SAMD Boards (32-bits ARM Cortex-M0+)")
      set (INST_TEST_PASS TRUE PARENT_SCOPE)
    else ()
      set (INST_TEST_PASS FALSE PARENT_SCOPE)
      message ("Failed subtest \"install\" (3)")
    endif ()
  endfunction ()
  
  function (test_core_upgrade)
    cmaw_upgrade_cores (ALL)
    
    cmaw_list_installed_cores (IDS VERSIONS LATESTS NAMES)
    
    list (FIND IDS "arduino:samd" ARDSAMD_INDEX)
    if (ARDSAMD_INDEX EQUAL -1)
      set (UPGR_TEST_PASS FALSE PARENT_SCOPE)
      message ("Failed subtest \"upgrade\" (1)")
      return ()
    endif ()
    
    list (GET VERSIONS ${ARDSAMD_INDEX} ARDSAMD_VER)
    list (GET LATESTS ${ARDSAMD_INDEX} ARDSAMD_LATEST)
    
    if (ARDSAMD_VER VERSION_EQUAL ARDSAMD_LATEST)
      set (UPGR_TEST_PASS TRUE PARENT_SCOPE)
    else ()
      set (UPGR_TEST_PASS FALSE PARENT_SCOPE)
      message ("Failed subtest \"upgrade\" (2)")
      return ()
    endif ()
  endfunction ()
  
  function (test_core_uninstall)
    cmaw_uninstall_cores ("arduino:samd")
    
    cmaw_list_installed_cores (IDS VERSIONS LATESTS NAMES)
    
    list (FIND IDS "arduino:samd" ARDSAMD_INDEX)
    if (ARDSAMD_INDEX EQUAL -1)
      set (UNINST_TEST_PASS TRUE PARENT_SCOPE)
    else ()
      set (UNINST_TEST_PASS FALSE PARENT_SCOPE)
      message ("Failed subtest \"uninstall\"")
    endif ()
    
  endfunction ()
  
  test_core_index ()
  test_core_list ()
  test_core_install ()
  test_core_upgrade ()
  test_core_uninstall ()
  
  if (INDEX_TEST_PASS AND LIST_TEST_PASS AND INST_TEST_PASS AND UPGR_TEST_PASS AND UNINST_TEST_PASS)
    set (TEST_PASS TRUE PARENT_SCOPE)
  else ()
    set (TEST_PASS FALSE PARENT_SCOPE)
  endif ()
endfunction ()

test_core ()
