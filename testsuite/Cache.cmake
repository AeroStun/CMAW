function (test_cache)
  cmaw_clean_arduino_cache ()
  set (TEST_PASS TRUE PARENT_SCOPE)
endfunction ()

test_cache ()
