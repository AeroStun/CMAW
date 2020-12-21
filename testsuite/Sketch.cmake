function (test_sketch)
  set (SKETCH_DIR "${TESTBENCH_TMPDIR}/sketch")
  set (SKETCH_FILE "${TESTBENCH_TMPDIR}/sketch/sketch.ino")
  cmaw_create_sketch ("${SKETCH_DIR}")
  
  if (EXISTS "${SKETCH_FILE}")
    set (TEST_PASS TRUE PARENT_SCOPE)
  else ()
    set (TEST_PASS FALSE PARENT_SCOPE)
  endif ()
endfunction ()

test_sketch ()
