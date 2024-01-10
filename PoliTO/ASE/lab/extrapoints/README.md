# Implementation of the game Quoridor for LandTiger board

> For compatibility with `Compiler v6` and the execution of Keil on Linux with wine, [core_cm3.c](Quoridor/core_cm3.c) was removed from the group `lib_SoC_board`, if any problem arises the file is still there and can be added but, based on this discussion on the [ARM Development Studio Forum](https://community.arm.com/support-forums/f/armds-forum/2770/compile-error-for-core_cm3-c) it seems that the file is no longer needed.
> From my testing it builds correctly both with compiler 5 and 6.

The implementation of the game was written using the emulator first and foremost, but was also tested on the board and runs way more smoothly on it. If testing on the board please comment out the `SIMULATOR` define in [main.c](Quoridor/main.c) to account for button bouncing.
