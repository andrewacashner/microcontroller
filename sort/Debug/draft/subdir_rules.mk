################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Each subdirectory must supply rules for building sources it contributes
draft/%.o: ../draft/%.s $(GEN_OPTS) | $(GEN_FILES) $(GEN_MISC_FILES)
	@echo 'Building file: "$<"'
	@echo 'Invoking: Arm Compiler'
	"/Applications/ti/ccs2001/ccs/tools/compiler/ti-cgt-armllvm_4.0.1.LTS/bin/tiarmclang" -c -march=thumbv6m -mcpu=cortex-m0plus -mfloat-abi=soft -mlittle-endian -mthumb -O0 -I"/Users/andrewacashner/Library/CloudStorage/OneDrive-MonroeCommunityCollege/Documents/MCC_code/CSC202-Microcontrollers/csc202_workspace/asm_playground" -I"/Users/andrewacashner/Library/CloudStorage/OneDrive-MonroeCommunityCollege/Documents/MCC_code/CSC202-Microcontrollers/csc202_workspace/asm_playground/Debug" -I"/Applications/ti/mspm0_sdk_2_01_00_03/source/third_party/CMSIS/Core/Include" -I"/Applications/ti/mspm0_sdk_2_01_00_03/source" -D__MSPM0G3507__ -gdwarf-3 $(GEN_OPTS__FLAG) -o"$@" "$<"
	@echo 'Finished building: "$<"'
	@echo ' '


