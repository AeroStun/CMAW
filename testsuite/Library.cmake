function (test_library)
  function (test_library_index)
    cmaw_update_library_index ()
    set (INDEX_TEST_PASS TRUE PARENT_SCOPE)
  endfunction ()
  
  function (test_library_list)
    cmaw_list_installed_libraries (NAMES VERSIONS AVAILS LOCS)
    
    list (LENGTH NAMES NAMES_COUNT)
    list (LENGTH VERSIONS VERSIONS_COUNT)
    list (LENGTH AVAILS AVAILS_COUNT)
    list (LENGTH LOCS LOCS_COUNT)
    
    if (NAMES_COUNT EQUAL VERSIONS_COUNT
        AND NAMES_COUNT EQUAL AVAILS_COUNT
        AND NAMES_COUNT EQUAL LOCS_COUNT)
      set (LIST_TEST_PASS TRUE PARENT_SCOPE)
    else ()
      set (LIST_TEST_PASS FALSE PARENT_SCOPE)
      message ("Failed subtest \"list\"")
    endif ()
  endfunction ()

  function (test_library_install)
    cmaw_install_libraries ("Smartcar shield" "LiquidCrystal@1.0.4")
    
    cmaw_list_installed_libraries (NAMES VERSIONS AVAILS LOCS)
    
    list (FIND NAMES "LiquidCrystal" LC_INDEX)
    if (LC_INDEX EQUAL -1)
      set (INST_TEST_PASS FALSE PARENT_SCOPE)
      message ("Failed subtest \"install\" (1)")
      return ()
    endif ()
    
    list (GET VERSIONS ${LC_INDEX} LC_VER)
    
    if (LC_VER VERSION_EQUAL "1.0.4")
      set (INST_TEST_PASS TRUE PARENT_SCOPE)
    else ()
      set (INST_TEST_PASS FALSE)
      message ("Failed subtest \"install\" (2)")
      return ()
    endif ()
    
    list (FIND NAMES "Smartcar_shield" SMCAR_INDEX)
    
    if (NOT SMCAR_INDEX EQUAL -1)
      set (INST_TEST_PASS TRUE PARENT_SCOPE)
    else ()
      set (INST_TEST_PASS FALSE PARENT_SCOPE)
      message ("Failed subtest \"install\" (3)")
    endif ()
  endfunction ()
  
  function (test_library_upgrade)
    cmaw_upgrade_libraries ("LiquidCrystal")
    
    cmaw_list_installed_libraries (NAMES VERSIONS AVAILS LOCS)
    
    list (FIND NAMES "LiquidCrystal" LC_INDEX)
    if (LC_INDEX EQUAL -1)
      set (UPGR_TEST_PASS FALSE PARENT_SCOPE)
      message ("Failed subtest \"upgrade\" (1)")
      return ()
    endif ()
    
    list (GET VERSIONS ${LC_INDEX} LC_VER)
    
    if (LC_VER VERSION_GREATER "1.0.4")
      set (UPGR_TEST_PASS TRUE PARENT_SCOPE)
    else ()
      set (UPGR_TEST_PASS FALSE PARENT_SCOPE)
      message ("Failed subtest \"upgrade\" (2)")
      return ()
    endif ()
  endfunction ()
  
  function (test_library_uninstall)
    cmaw_uninstall_libraries ("LiquidCrystal")
    
    cmaw_list_installed_libraries (NAMES VERSIONS AVAILS LOCS)
    
    list (FIND NAMES "LiquidCrystal" LC_INDEX)
    if (LC_INDEX EQUAL -1)
      set (UNINST_TEST_PASS TRUE PARENT_SCOPE)
    else ()
      set (UNINST_TEST_PASS FALSE PARENT_SCOPE)
      message ("Failed subtest \"uninstall\"")
    endif ()
    
  endfunction ()
  
  test_library_index ()
  test_library_list ()
  test_library_install ()
  test_library_upgrade ()
  test_library_uninstall ()
  
  if (INDEX_TEST_PASS AND LIST_TEST_PASS AND INST_TEST_PASS AND UPGR_TEST_PASS AND UNINST_TEST_PASS)
    set (TEST_PASS TRUE PARENT_SCOPE)
  else ()
    set (TEST_PASS FALSE PARENT_SCOPE)
  endif ()
endfunction ()

test_library ()
