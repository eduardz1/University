# CMSIS Build CMakeLists generated on 2024-01-10T18:53:29

cmake_minimum_required(VERSION 3.22)

# Target options

set(TARGET quoridor)
set(CPU Cortex-M3)
set(PRJ_DIR "c:/Users/occhi/Github/eduardz1/University/PoliTO/ASE/lab/extrapoints/Quoridor")
set(OUT_DIR "C:/Users/occhi/Github/eduardz1/University/PoliTO/ASE/lab/extrapoints/Quoridor/out/quoridor/Quoridor")
set(INT_DIR "C:/Users/occhi/Github/eduardz1/University/PoliTO/ASE/lab/extrapoints/Quoridor/tmp/quoridor/Quoridor")
set(FPU NO_FPU)
set(SECURE Non-secure)
set(BYTE_ORDER Little-endian)
set(OPTIMIZE speed)
set(DEBUG on)
set(AS_FLAGS_GLOBAL "-masm=auto")
set(CC_FLAGS_GLOBAL "-std=c99 -fno-rtti -funsigned-char -fshort-enums -fshort-wchar -fno-function-sections")
set(CXX_FLAGS_GLOBAL "-xc++ -std=c++03 -fno-rtti -funsigned-char -fshort-enums -fshort-wchar -fno-function-sections")
set(LD_FLAGS_GLOBAL "--map --load_addr_map_info --xref --callgraph --symbols --info sizes --info totals --info unused --info veneers --strict --summary_stderr --info summarysizes")
set(LD_SCRIPT "c:/Users/occhi/Github/eduardz1/University/PoliTO/ASE/lab/extrapoints/Quoridor/quoridor_Quoridor.sct")

set(DEFINES
  LPC175x_6x
  _RTE_
)

set(INC_PATHS
  "c:/Users/occhi/Github/eduardz1/University/PoliTO/ASE/lab/extrapoints/Quoridor/RTE/_Quoridor"
  "C:/Users/occhi/AppData/Local/Arm/Packs/ARM/CMSIS/5.9.0/CMSIS/Core/Include"
  "C:/Users/occhi/AppData/Local/arm/packs/Keil/LPC1700_DFP/2.7.1/Device/Include"
  "c:/Users/occhi/Github/eduardz1/University/PoliTO/ASE/lab/extrapoints/Quoridor"
  "c:/Users/occhi/Github/eduardz1/University/PoliTO/ASE/lab/extrapoints/Quoridor/GLCD"
  "c:/Users/occhi/Github/eduardz1/University/PoliTO/ASE/lab/extrapoints/Quoridor/TouchPanel"
  "c:/Users/occhi/Github/eduardz1/University/PoliTO/ASE/lab/extrapoints/Quoridor/utils"
  "c:/Users/occhi/Github/eduardz1/University/PoliTO/ASE/lab/extrapoints/Quoridor/imgs"
  "c:/Users/occhi/Github/eduardz1/University/PoliTO/ASE/lab/extrapoints/Quoridor/button_EXINT"
  "c:/Users/occhi/Github/eduardz1/University/PoliTO/ASE/lab/extrapoints/Quoridor/joystick"
  "c:/Users/occhi/Github/eduardz1/University/PoliTO/ASE/lab/extrapoints/Quoridor/led"
  "c:/Users/occhi/Github/eduardz1/University/PoliTO/ASE/lab/extrapoints/Quoridor/RIT"
  "c:/Users/occhi/Github/eduardz1/University/PoliTO/ASE/lab/extrapoints/Quoridor/game"
)

set(AS_ARM_SRC_FILES
  "c:/Users/occhi/Github/eduardz1/University/PoliTO/ASE/lab/extrapoints/Quoridor/startup_LPC17xx.s"
)

set(CC_SRC_FILES
  "c:/Users/occhi/Github/eduardz1/University/PoliTO/ASE/lab/extrapoints/Quoridor/GLCD/AsciiLib.c"
  "c:/Users/occhi/Github/eduardz1/University/PoliTO/ASE/lab/extrapoints/Quoridor/GLCD/GLCD.c"
  "c:/Users/occhi/Github/eduardz1/University/PoliTO/ASE/lab/extrapoints/Quoridor/GLCD/HzLib.c"
  "c:/Users/occhi/Github/eduardz1/University/PoliTO/ASE/lab/extrapoints/Quoridor/RIT/IRQ_RIT.c"
  "c:/Users/occhi/Github/eduardz1/University/PoliTO/ASE/lab/extrapoints/Quoridor/RIT/lib_RIT.c"
  "c:/Users/occhi/Github/eduardz1/University/PoliTO/ASE/lab/extrapoints/Quoridor/TouchPanel/TouchPanel.c"
  "c:/Users/occhi/Github/eduardz1/University/PoliTO/ASE/lab/extrapoints/Quoridor/button_EXINT/IRQ_button.c"
  "c:/Users/occhi/Github/eduardz1/University/PoliTO/ASE/lab/extrapoints/Quoridor/button_EXINT/lib_button.c"
  "c:/Users/occhi/Github/eduardz1/University/PoliTO/ASE/lab/extrapoints/Quoridor/game/game.c"
  "c:/Users/occhi/Github/eduardz1/University/PoliTO/ASE/lab/extrapoints/Quoridor/game/graphics.c"
  "c:/Users/occhi/Github/eduardz1/University/PoliTO/ASE/lab/extrapoints/Quoridor/imgs/cell.c"
  "c:/Users/occhi/Github/eduardz1/University/PoliTO/ASE/lab/extrapoints/Quoridor/imgs/player.c"
  "c:/Users/occhi/Github/eduardz1/University/PoliTO/ASE/lab/extrapoints/Quoridor/imgs/wall.c"
  "c:/Users/occhi/Github/eduardz1/University/PoliTO/ASE/lab/extrapoints/Quoridor/joystick/funct_joystick.c"
  "c:/Users/occhi/Github/eduardz1/University/PoliTO/ASE/lab/extrapoints/Quoridor/joystick/lib_joystick.c"
  "c:/Users/occhi/Github/eduardz1/University/PoliTO/ASE/lab/extrapoints/Quoridor/led/funct_led.c"
  "c:/Users/occhi/Github/eduardz1/University/PoliTO/ASE/lab/extrapoints/Quoridor/led/lib_led.c"
  "c:/Users/occhi/Github/eduardz1/University/PoliTO/ASE/lab/extrapoints/Quoridor/main.c"
  "c:/Users/occhi/Github/eduardz1/University/PoliTO/ASE/lab/extrapoints/Quoridor/system_LPC17xx.c"
  "c:/Users/occhi/Github/eduardz1/University/PoliTO/ASE/lab/extrapoints/Quoridor/utils/dynarray.c"
  "c:/Users/occhi/Github/eduardz1/University/PoliTO/ASE/lab/extrapoints/Quoridor/utils/stack.c"
)

# Toolchain config map

set(TOOLCHAIN_VERSION_MIN "6.19.0")
set(TOOLCHAIN_VERSION_MAX "6.19.0")
include ("C:/Users/occhi/.vcpkg/artifacts/fd3d78d7/tools.open.cmsis.pack.cmsis.toolbox/2.2.1/etc/AC6.6.18.0.cmake")
include ("C:/Users/occhi/.vcpkg/artifacts/fd3d78d7/tools.open.cmsis.pack.cmsis.toolbox/2.2.1/etc/CMSIS-Build-Utils.cmake")

# Setup project

project(${TARGET} LANGUAGES AS_ARM C)

cbuild_get_running_toolchain(TOOLCHAIN_ROOT TOOLCHAIN_VERSION C)

# Global Flags

set(CMAKE_AS_ARM_FLAGS "${AS_ARM_CPU} ${AS_ARM_BYTE_ORDER} ${AS_ARM_DEFINES} ${AS_ARM_OPTIONS_FLAGS} ${AS_ARM_FLAGS} ${AS_FLAGS_GLOBAL}")
cbuild_get_system_includes(CC_SYS_INC_PATHS_LIST CC_SYS_INC_PATHS)
set(CMAKE_C_FLAGS "${CC_CPU} ${CC_BYTE_ORDER} ${CC_DEFINES} ${CC_SECURE} ${CC_OPTIONS_FLAGS} ${CC_FLAGS} ${CC_FLAGS_GLOBAL} ${CC_SYS_INC_PATHS}")
set(CMAKE_C_LINK_FLAGS "${LD_CPU} ${_LS}\"${LD_SCRIPT}\" ${LD_SECURE} ${LD_FLAGS_GLOBAL} ${LD_OPTIONS_FLAGS} ${LD_FLAGS}")

# Local Flags

foreach(SRC ${AS_ARM_SRC_FILES})
  set_source_files_properties(${SRC} PROPERTIES LANGUAGE AS_ARM)
endforeach()

# Compilation Database

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
add_custom_target(database COMMAND ${CMAKE_COMMAND} -E copy_if_different "${INT_DIR}/compile_commands.json" "${OUT_DIR}")

# Setup Target

add_executable(${TARGET} ${AS_ARM_SRC_FILES} ${CC_SRC_FILES})
set_target_properties(${TARGET} PROPERTIES PREFIX "" SUFFIX ".axf" OUTPUT_NAME "quoridor")
set_target_properties(${TARGET} PROPERTIES RUNTIME_OUTPUT_DIRECTORY ${OUT_DIR} LINK_DEPENDS ${LD_SCRIPT})
target_include_directories(${TARGET} PUBLIC ${INC_PATHS})
