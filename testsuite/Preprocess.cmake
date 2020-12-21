function (test_preproc)
  set (SKETCH_DIR "${TESTBENCH_TMPDIR}/preproc")
  set (SKETCH_FILE "${SKETCH_DIR}/preproc.ino")
  
  file (MAKE_DIRECTORY "${SKETCH_DIR}")
  file (WRITE "${SKETCH_FILE}" "void foobar();")
  
  cmaw_preprocess (PREPROCESSED "arduino:avr:nano" "${SKETCH_DIR}")
  
  if (PREPROCESSED STREQUAL "#include <Arduino.h>\n#line 1 \"${SKETCH_FILE}\"\nvoid foobar();\n\n")
    set (TEST_PASS TRUE PARENT_SCOPE)
  else ()
    set (TEST_PASS FALSE PARENT_SCOPE)
  endif ()
endfunction ()

test_preproc ()
