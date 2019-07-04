# ----------------------------------------------------------------------------
#  
#        ** **        **          **  ****      **  **********  ********** ® 
#       **   **        **        **   ** **     **  **              ** 
#      **     **        **      **    **  **    **  **              ** 
#     **       **        **    **     **   **   **  *********       ** 
#    **         **        **  **      **    **  **  **              ** 
#   **           **        ****       **     ** **  **              ** 
#  **  .........  **        **        **      ****  **********      ** 
#     ........... 
#                                     Reach Further™ 
#  
# ----------------------------------------------------------------------------
# 
# This design is the property of Avnet.  Publication of this 
# design is not authorized without written consent from Avnet. 
# 
# Please direct any questions to the PicoZed community support forum: 
#    http://www.zedboard.org/forum 
# 
# Disclaimer: 
#    Avnet, Inc. makes no warranty for the use of this code or design. 
#    This code is provided  "As Is". Avnet, Inc assumes no responsibility for 
#    any errors, which may appear in this code, nor does it make a commitment 
#    to update the information contained herein. Avnet, Inc specifically 
#    disclaims any implied warranties of fitness for a particular purpose. 
#                     Copyright(c) 2017 Avnet, Inc. 
#                             All rights reserved. 
# 
# ----------------------------------------------------------------------------
# 
#  Create Date:         June 22, 2015
#  Design Name:         
#  Module Name:         
#  Project Name:        
#  Target Devices:      
#  Hardware Boards:     FMC-HDMI-CAM + PYTHON-1300-C
# 
#  Tool versions:       Vivado 2016.4
# 
#  Description:         SDK Build Script for FMC-HDMI-CAM + PYTHON-1300-C Design
# 
#  Dependencies:        To be called from a configured make script call

#
#  Revision:            Jun 22, 2015: 1.00 Initial version for Vivado 2014.4
#                       Nov 16, 2015: 1.01 Updated for Vivado 2015.2
#                       May 29, 2017: 1.02 Updated for Vivado 2016.4
# 
# ----------------------------------------------------------------------------


#!/usr/bin/tclsh
set project  "fmchc_python1300c"
set hw_name  "fmchc_python1300c_hw"
set r5_bsp_name "fmchc_python1300c_r5_bsp"
set a53_bsp_name "fmchc_python1300c_a53_bsp"
set app_name "fmchc_python1300c_app"
set fsbl_name "zynq_fsbl_app"

# Set workspace and import hardware platform
setws ${project}.sdk

puts "\n#\n#\n# Adding local user repository ...\n#\n#\n"
repo -set ../../../avnet/Projects/${project}/software/sw_repository

puts "\n#\n#\n# Importing hardware definition ${hw_name} from impl_1 folder ...\n#\n#\n"
file copy -force ${project}.runs/impl_1/${project}_wrapper.sysdef ${project}.sdk/${hw_name}.hdf
if {[file exists ${project}.sdk/${project}_hw/system.hdf]} {
    puts "\n#\n#\n# Open hardware definition project ...\n#\n#\n"
    openhw ${hw_name}
} else {
    puts "\n#\n#\n# Create hardware definition project ...\n#\n#\n"
    sdk createhw -name ${hw_name} -hwspec ${project}.sdk/${hw_name}.hdf
}

# Generate BSP
puts "\n#\n#\n# Creating ${r5_bsp_name} ...\n#\n#\n"
if {[catch {deleteprojects -name ${r5_bsp_name}} errmsg]} {
   puts "ErrorMsg: $errmsg"
   puts "ErrorCode: $errorCode"
   puts "ErrorInfo:\n$errorInfo\n"
}
createbsp -name ${r5_bsp_name} -proc psu_cortexr5_0 -hwproject ${hw_name} -os standalone
# add libraries for FSBL
setlib -bsp ${r5_bsp_name} -lib xilffs
setlib -bsp ${r5_bsp_name} -lib xilsecure
setlib -bsp ${r5_bsp_name} -lib xilpm
# add libraries for APP
#setlib -bsp ${r5_bsp_name} -lib fmc_iic_sw
#setlib -bsp ${r5_bsp_name} -lib fmc_hdmi_cam_sw
#setlib -bsp ${r5_bsp_name} -lib onsemi_python_sw
# regen and build
regenbsp -hw ${hw_name} -bsp ${r5_bsp_name}
projects -build -type bsp -name ${r5_bsp_name}

puts "\n#\n#\n# Creating ${a53_bsp_name} ...\n#\n#\n"
if {[catch {deleteprojects -name ${a53_bsp_name}} errmsg]} {
   puts "ErrorMsg: $errmsg"
   puts "ErrorCode: $errorCode"
   puts "ErrorInfo:\n$errorInfo\n"
}
createbsp -name ${a53_bsp_name} -proc psu_cortexa53_0 -hwproject ${hw_name} -os standalone
# add libraries for FSBL
setlib -bsp ${a53_bsp_name} -lib xilffs
setlib -bsp ${a53_bsp_name} -lib xilsecure
setlib -bsp ${a53_bsp_name} -lib xilpm
# add libraries for APP
setlib -bsp ${a53_bsp_name} -lib fmc_iic_sw
setlib -bsp ${a53_bsp_name} -lib fmc_hdmi_cam_sw
setlib -bsp ${a53_bsp_name} -lib onsemi_python_sw
# regen and build
regenbsp -hw ${hw_name} -bsp ${a53_bsp_name}
projects -build -type bsp -name ${a53_bsp_name}

# Create APP
puts "\n#\n#\n# Creating ${app_name} ...\n#\n#\n"
if {[catch {deleteprojects -name ${app_name}} errmsg]} {
   puts "ErrorMsg: $errmsg"
   puts "ErrorCode: $errorCode"
   puts "ErrorInfo:\n$errorInfo\n"
}
createapp -name ${app_name} -hwproject ${hw_name} -proc psu_cortexa53_0 -os standalone -lang C -app {Empty Application} -bsp ${a53_bsp_name} 

# APP : copy sources to empty application
importsources -name ${app_name} -path ../../../avnet/Projects/${project}/software/${app_name}/src

# build APP
puts "\n#\n#\n# Build ${app_name} ...\n#\n#\n"
projects -build -type app -name ${app_name}

# Create Zynq FSBL application
puts "\n#\n#\n# Creating FSBL ...\n#\n#\n"
if {[catch {deleteprojects -name ${fsbl_name}} errmsg]} {
   puts "ErrorMsg: $errmsg"
   puts "ErrorCode: $errorCode"
   puts "ErrorInfo:\n$errorInfo\n"
}
#createapp -name zynq_fsbl_app -hwproject ${hw_name} -proc ps7_cortexa53_0 -os standalone -lang C -app {Zynq FSBL} -bsp zynq_fsbl_bsp
createapp -name ${fsbl_name} -hwproject ${hw_name} -proc psu_cortexr5_0 -os standalone -lang C -app {Zynq MP FSBL} -bsp ${r5_bsp_name}

# Patch FSBL application
# disable NAND/QSPI/Secure Boot to save FSBL size
set current [pwd]
puts "${current}"
cd ${project}.sdk/${fsbl_name}/src
puts "[pwd]"
exec >@stdout 2>@stderr patch -p1 < ../../../../../../scripts/0001-disable-NAND-QSPI-and-Secure-boot-to-save-fsbl-size.patch
cd ${current}

# Set the build type to release
configapp -app ${fsbl_name} build-config release

# Build FSBL application
puts "\n#\n#\n Building zynq_fsbl ...\n#\n#\n"
#projects -build -type bsp -name ${fsbl_name}
projects -build -type app -name ${fsbl_name}

# done
exit
