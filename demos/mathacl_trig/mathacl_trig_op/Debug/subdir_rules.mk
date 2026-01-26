################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Each subdirectory must supply rules for building sources it contributes
%.o: ../%.c $(GEN_OPTS) | $(GEN_FILES) $(GEN_MISC_FILES)
	@echo 'Building file: "$<"'
	@echo 'Invoking: Arm Compiler'
	"/Applications/ti/ccs2001/ccs/tools/compiler/ti-cgt-armllvm_4.0.4.LTS/bin/tiarmclang" -c @"device.opt"  -march=thumbv6m -mcpu=cortex-m0plus -mfloat-abi=soft -mlittle-endian -mthumb -O2 -I"/Users/andrewacashner/Documents/microcontroller/demos/mathacl_trig/mathacl_trig_op" -I"/Users/andrewacashner/Documents/microcontroller/demos/mathacl_trig/mathacl_trig_op/Debug" -I"/Users/andrewacashner/ti/mspm0_sdk_2_09_00_01/source/third_party/CMSIS/Core/Include" -I"/Users/andrewacashner/ti/mspm0_sdk_2_09_00_01/source" -gdwarf-3 -MMD -MP -MF"$(basename $(<F)).d_raw" -MT"$(@)"  $(GEN_OPTS__FLAG) -o"$@" "$<"
	@echo 'Finished building: "$<"'
	@echo ' '

build-9623210: ../mathacl_trig_op.syscfg
	@echo 'Building file: "$<"'
	@echo 'Invoking: SysConfig'
	"/Users/andrewacashner/ti/sysconfig_1.25.0/sysconfig_cli.sh" -s "/Users/andrewacashner/ti/mspm0_sdk_2_09_00_01/.metadata/product.json" --script "/Users/andrewacashner/Documents/microcontroller/demos/mathacl_trig/mathacl_trig_op/mathacl_trig_op.syscfg" -o "." --compiler ticlang
	@echo 'Finished building: "$<"'
	@echo ' '

device_linker.cmd: build-9623210 ../mathacl_trig_op.syscfg
device.opt: build-9623210
device.cmd.genlibs: build-9623210
ti_msp_dl_config.c: build-9623210
ti_msp_dl_config.h: build-9623210
Event.dot: build-9623210

%.o: ./%.c $(GEN_OPTS) | $(GEN_FILES) $(GEN_MISC_FILES)
	@echo 'Building file: "$<"'
	@echo 'Invoking: Arm Compiler'
	"/Applications/ti/ccs2001/ccs/tools/compiler/ti-cgt-armllvm_4.0.4.LTS/bin/tiarmclang" -c @"device.opt"  -march=thumbv6m -mcpu=cortex-m0plus -mfloat-abi=soft -mlittle-endian -mthumb -O2 -I"/Users/andrewacashner/Documents/microcontroller/demos/mathacl_trig/mathacl_trig_op" -I"/Users/andrewacashner/Documents/microcontroller/demos/mathacl_trig/mathacl_trig_op/Debug" -I"/Users/andrewacashner/ti/mspm0_sdk_2_09_00_01/source/third_party/CMSIS/Core/Include" -I"/Users/andrewacashner/ti/mspm0_sdk_2_09_00_01/source" -gdwarf-3 -MMD -MP -MF"$(basename $(<F)).d_raw" -MT"$(@)"  $(GEN_OPTS__FLAG) -o"$@" "$<"
	@echo 'Finished building: "$<"'
	@echo ' '

startup_mspm0g350x_ticlang.o: /Users/andrewacashner/ti/mspm0_sdk_2_09_00_01/source/ti/devices/msp/m0p/startup_system_files/ticlang/startup_mspm0g350x_ticlang.c $(GEN_OPTS) | $(GEN_FILES) $(GEN_MISC_FILES)
	@echo 'Building file: "$<"'
	@echo 'Invoking: Arm Compiler'
	"/Applications/ti/ccs2001/ccs/tools/compiler/ti-cgt-armllvm_4.0.4.LTS/bin/tiarmclang" -c @"device.opt"  -march=thumbv6m -mcpu=cortex-m0plus -mfloat-abi=soft -mlittle-endian -mthumb -O2 -I"/Users/andrewacashner/Documents/microcontroller/demos/mathacl_trig/mathacl_trig_op" -I"/Users/andrewacashner/Documents/microcontroller/demos/mathacl_trig/mathacl_trig_op/Debug" -I"/Users/andrewacashner/ti/mspm0_sdk_2_09_00_01/source/third_party/CMSIS/Core/Include" -I"/Users/andrewacashner/ti/mspm0_sdk_2_09_00_01/source" -gdwarf-3 -MMD -MP -MF"$(basename $(<F)).d_raw" -MT"$(@)"  $(GEN_OPTS__FLAG) -o"$@" "$<"
	@echo 'Finished building: "$<"'
	@echo ' '


