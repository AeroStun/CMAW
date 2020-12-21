# CMAW - CMake Arduino[CLI] Wrapper

![master testsuite badge](https://github.com/AeroStun/CMAW/workflows/Testsuite/badge.svg?branch=master)

If you want to manage an arduino-cli installation from CMake scripts, or build simple sketches on a headless environment (such as a CI pipeline), CMAW is for you.

## Usage

`CMAW` is a CMake module. It can be included in both build and script files.

Download `CMAW.cmake` from this repository, and put it somewhere in a folder you added to your `CMAKE_MODULE_PATH`.
To do this at configure time, you can simply write:
```cmake
set (CMAW_URL "https://github.com/AeroStun/CMAW/raw/master/CMAW.cmake")
set (CMAW_RUNDIR "${CMAKE_BINARY_DIR}/runmodules")
set (CMAW_RUNLOC "${CMAW_RUNDIR}/CMAW.cmake")
if (NOT EXISTS "${CMAW_RUNLOC}")
  file (MAKE_DIRECTORY "${CMAW_RUNDIR}")
  file (DOWNLOAD "${CMAW_URL}" "${CMAW_RUNLOC}")
  list (APPEND CMAKE_MODULE_PATH "${CMAW_RUNDIR}")
endif ()

include (CMAW)
```

All function and macro names starting by `cmaw_` should be considered reserved for CMAW.  
All variable names starting by `CMAW_` should be considered reserved for CMAW.  
All functions, macros, and variables starting by `cmaw_internal` or `CMAW_INTERNAL` should be considered implementation details and never used directly.

## Testsuite

To run the testsuite, set the environment variable `ARDUINOCLI_VER` to the version of the ArduinoCLI installation, and run:
```sh
cmake -P testsuite/Main.cmake
```

## Configuration variables

- `CMAW_ARDUINOCLI_DL_VERSION` \["latest"\]: arduino-cli version to use if there is need to download it.
- `CMAW_ARDUINOCLI_BINARY_LOCATION` \[""\]: Path to an existing arduino-cli binary on disk; empty to autodetect.
- `CMAW_ARDUINOCLI_BINARY_NOSYSTEM` \[OFF\]: When enabled, CMAW will skip searching for arduino-cli on the system.

## Informational variables

- `CMAW_VERSION`: CMAW's version string (format: "major.minor.patch")

## Functions

- `cmaw_arduinocli_version (<out-var>)`: sets variable `<out-var>` to the ArduinoCLI version-string.
- `cmaw_init_config (<destination-dir>)`: creates a default config file in `<destination-dir>`.
- `cmaw_dump_config (<out-var> [JSON])`: dumps the ArduinoCLI config (YAML) into the variable `<out-var>`. Specify the `JSON` flag to get the output in JSON format ([CMake has some support for reading JSON](https://cmake.org/cmake/help/latest/command/string.html#json)).
- `cmaw_update_core_index ()`: updates the ArduinoCLI index file for cores.
- `cmaw_list_installed_cores (<ids-out-list> <versions-out-list> <latests-out-list> <names-out-list>)`: lists the installed cores and stores the content of each column in its respective list.
- `cmaw_install_cores (<packager>:<arch>[@<version>]...)`: installs the specified cores.
- `cmaw_uninstall_cores (<packager>:<arch>...)`: uninstalls the specified cores.
- `cmaw_upgrade_cores (<packager>:<arch>...)`: upgrades the specified cores.
- `cmaw_upgrade_cores (ALL)`: upgrades all the cores.
- `cmaw_list_known_boards (<names-out-list> <fqbns-out-list>)`
- `cmaw_list_connected_boards (<ports-out-list> <types-out-list> <events-out-list> <names-out-list> <fqbns-out-list> <cores-out-list>)`: lists the connected boards and stores the content of each column in its respective list.
- `cmaw_list_installed_libraries (<names-out-list> <versions-out-list> <availabilities-out-list> <locations-out-list>)`: list the installed libraries and stores the content of each column in its respective list.
- `cmaw_update_library_index ()`: updates the ArduinoCLI index files for libraries.
- `cmaw_install_libraries (<name>[@<version>]... [NO_DEPS])`: installs the specified libraries. Specify `NO_DEPS` to prevent the dependencies of these libraries from being installed as well.
- `cmaw_uninstall_libraries (<lib-name>...)`: uninstalls the specified libraries.
- `cmaw_upgrade_libraries (<lib-name>...)`: upgrades the specified libraries.
- `cmaw_upgrade_libraries (ALL)`: upgrades all the libraries.
- `cmaw_clean_arduino_cache ()`: cleans the Arduino cache.
- `cmaw_create_sketch (<name>):` creates a named sketch (in the default sketch location).
- `cmaw_preprocess (<out-var> <fqbn> "path/to/sketch")`: preprocesses sketch with the provided board and stores the ouput in `<out-var>`

## Experimental (Untested) Features

- ArduinoCLI autodownload: if no path for `arduino-cli` is provided, and that there is no system installed version (or the check was disabled via `CMAW_ARDUINOCLI_NOSYSTEM`), CMAW will setup its own local installation.
- Function `add_arduino_sketch`: Analogous to `add_executable`. Supports custom compiler options (assume GNU), compile definitions, and include directories.

## TODO

_Highest priority first, lowest last._

- CI config with matrix of all supported CMake and ArduinoCLI versions
- Intentional support for sketch directories
- User-defined configuration file location
- Support for compilation and preprocessing with custom (local) libraries
- Function `cmaw_compile_sketch`
- Uploading support
- Better error handling
