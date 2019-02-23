
################################################################
# This is a generated script based on design: fmchc_python1300c
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2018.3
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   common::send_msg_id "BD_TCL-1002" "WARNING" "This script was generated using Vivado <$scripts_vivado_version> without IP versions in the create_bd_cell commands, but is now being run in <$current_vivado_version> of Vivado. There may have been major IP version changes between Vivado <$scripts_vivado_version> and <$current_vivado_version>, which could impact the parameter settings of the IPs."

}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source fmchc_python1300c_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

#set list_projs [get_projects -quiet]
#if { $list_projs eq "" } {
#   create_project project_1 myproj -part xc7z030sbg485-1
#   set_property BOARD_PART em.avnet.com:picozed_7030_fmc2:part0:1.1 [current_project]
#}


# CHANGE DESIGN NAME HERE
#set design_name fmchc_python1300c

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

#set cur_design [current_bd_design -quiet]
#set list_cells [get_bd_cells -quiet]
#
#if { ${design_name} eq "" } {
#   # USE CASES:
#   #    1) Design_name not set
#
#   set errMsg "Please set the variable <design_name> to a non-empty value."
#   set nRet 1
#
#} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
#   # USE CASES:
#   #    2): Current design opened AND is empty AND names same.
#   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
#   #    4): Current design opened AND is empty AND names diff; design_name exists in project.
#
#   if { $cur_design ne $design_name } {
#      common::send_msg_id "BD_TCL-001" "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
#      set design_name [get_property NAME $cur_design]
#   }
#   common::send_msg_id "BD_TCL-002" "INFO" "Constructing design in IPI design <$cur_design>..."
#
#} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
#   # USE CASES:
#   #    5) Current design opened AND has components AND same names.
#
#   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
#   set nRet 1
#} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
#   # USE CASES:
#   #    6) Current opened design, has components, but diff names, design_name exists in project.
#   #    7) No opened design, design_name exists in project.
#
#   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
#   set nRet 2
#
#} else {
#   # USE CASES:
#   #    8) No opened design, design_name not in project.
#   #    9) Current opened design, has components, but diff names, design_name not in project.
#
#   common::send_msg_id "BD_TCL-003" "INFO" "Currently there is no design <$design_name> in project, so creating one..."
#
#   create_bd_design $design_name
#
#   common::send_msg_id "BD_TCL-004" "INFO" "Making design <$design_name> as current_bd_design."
#   current_bd_design $design_name
#
#}

common::send_msg_id "BD_TCL-005" "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_msg_id "BD_TCL-114" "ERROR" $errMsg}
   return $nRet
}

##################################################################
# DESIGN PROCs
##################################################################



# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  #set DDR [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 DDR ]
  #set FIXED_IO [ create_bd_intf_port -mode Master -vlnv xilinx.com:display_processing_system7:fixedio_rtl:1.0 FIXED_IO ]
  set IO_HDMII [ create_bd_intf_port -mode Slave -vlnv avnet.com:interface:avnet_hdmi_rtl:2.0 IO_HDMII ]
  set IO_HDMIO [ create_bd_intf_port -mode Master -vlnv avnet.com:interface:avnet_hdmi_rtl:2.0 IO_HDMIO ]
  set IO_PYTHON_CAM [ create_bd_intf_port -mode Slave -vlnv avnet.com:interface:onsemi_vita_cam_rtl:1.0 IO_PYTHON_CAM ]
  set IO_PYTHON_SPI [ create_bd_intf_port -mode Master -vlnv avnet.com:interface:onsemi_vita_spi_rtl:1.0 IO_PYTHON_SPI ]
  set fmc_hdmi_cam_iic [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 fmc_hdmi_cam_iic ]

  # Create ports
  #set M_AXI_GP0_ACLK [ create_bd_port -dir I -type clk M_AXI_GP0_ACLK ]
  set fmc_hdmi_cam_iic_rst_n [ create_bd_port -dir O -from 0 -to 0 fmc_hdmi_cam_iic_rst_n ]
  set fmc_hdmi_cam_vclk [ create_bd_port -dir I fmc_hdmi_cam_vclk ]

  # Create instance: avnet_hdmi_in_0, and set properties
  set avnet_hdmi_in_0 [ create_bd_cell -type ip -vlnv avnet:avnet_hdmi:avnet_hdmi_in avnet_hdmi_in_0 ]
  set_property -dict [ list \
CONFIG.C_USE_BUFR {true} \
 ] $avnet_hdmi_in_0

  # Create instance: avnet_hdmi_out_0, and set properties
  set avnet_hdmi_out_0 [ create_bd_cell -type ip -vlnv avnet:avnet_hdmi:avnet_hdmi_out avnet_hdmi_out_0 ]
  set_property -dict [ list \
CONFIG.C_DEBUG_PORT {false} \
 ] $avnet_hdmi_out_0

  # Create instance: axi_mem_intercon, and set properties
  set axi_mem_intercon [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect axi_mem_intercon ]
  set_property -dict [ list \
CONFIG.NUM_MI {1} \
CONFIG.NUM_SI {4} \
 ] $axi_mem_intercon

  # Create instance: axi_vdma_0, and set properties
  set axi_vdma_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vdma axi_vdma_0 ]
  set_property -dict [ list \
CONFIG.c_m_axi_s2mm_data_width {64} \
CONFIG.c_m_axis_mm2s_tdata_width {16} \
CONFIG.c_mm2s_linebuffer_depth {512} \
CONFIG.c_mm2s_max_burst_length {256} \
CONFIG.c_s2mm_linebuffer_depth {4096} \
CONFIG.c_s2mm_max_burst_length {256} \
 ] $axi_vdma_0

  # Create instance: axi_vdma_1, and set properties
  set axi_vdma_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vdma axi_vdma_1 ]
  set_property -dict [ list \
CONFIG.c_m_axi_s2mm_data_width {64} \
CONFIG.c_m_axis_mm2s_tdata_width {16} \
CONFIG.c_mm2s_linebuffer_depth {4096} \
CONFIG.c_mm2s_max_burst_length {256} \
CONFIG.c_s2mm_linebuffer_depth {4096} \
CONFIG.c_s2mm_max_burst_length {256} \
 ] $axi_vdma_1

  # Create instance: clk_wiz_0, and set properties
  set clk_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz clk_wiz_0 ]
  set_property -dict [ list \
CONFIG.CLKIN1_JITTER_PS {67.34} \
CONFIG.CLKOUT1_JITTER {103.270} \
CONFIG.CLKOUT1_PHASE_ERROR {86.054} \
CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {148.5} \
CONFIG.CLKOUT2_JITTER {109.684} \
CONFIG.CLKOUT2_PHASE_ERROR {86.054} \
CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {108} \
CONFIG.CLKOUT2_USED {true} \
CONFIG.MMCM_CLKFBOUT_MULT_F {8.000} \
CONFIG.MMCM_CLKIN1_PERIOD {6.734} \
CONFIG.MMCM_CLKIN2_PERIOD {10.0} \
CONFIG.MMCM_CLKOUT0_DIVIDE_F {8.000} \
CONFIG.MMCM_CLKOUT1_DIVIDE {11} \
CONFIG.MMCM_COMPENSATION {ZHOLD} \
CONFIG.NUM_OUT_CLKS {2} \
CONFIG.PRIM_IN_FREQ {148.5} \
CONFIG.USE_LOCKED {false} \
CONFIG.USE_RESET {false} \
 ] $clk_wiz_0

  # Need to retain value_src of defaults
  set_property -dict [ list \
CONFIG.CLKIN1_JITTER_PS.VALUE_SRC {DEFAULT} \
CONFIG.CLKOUT1_JITTER.VALUE_SRC {DEFAULT} \
CONFIG.CLKOUT1_PHASE_ERROR.VALUE_SRC {DEFAULT} \
CONFIG.CLKOUT2_JITTER.VALUE_SRC {DEFAULT} \
CONFIG.CLKOUT2_PHASE_ERROR.VALUE_SRC {DEFAULT} \
CONFIG.MMCM_CLKFBOUT_MULT_F.VALUE_SRC {DEFAULT} \
CONFIG.MMCM_CLKIN1_PERIOD.VALUE_SRC {DEFAULT} \
CONFIG.MMCM_CLKIN2_PERIOD.VALUE_SRC {DEFAULT} \
CONFIG.MMCM_CLKOUT0_DIVIDE_F.VALUE_SRC {DEFAULT} \
CONFIG.MMCM_CLKOUT1_DIVIDE.VALUE_SRC {DEFAULT} \
CONFIG.MMCM_COMPENSATION.VALUE_SRC {DEFAULT} \
 ] $clk_wiz_0

  # Create instance: fmc_hdmi_cam_iic_0, and set properties
  set fmc_hdmi_cam_iic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic fmc_hdmi_cam_iic_0 ]
  set_property -dict [ list \
CONFIG.IIC_BOARD_INTERFACE {Custom} \
CONFIG.USE_BOARD_FLOW {true} \
 ] $fmc_hdmi_cam_iic_0

  # Create instance: onsemi_python_cam_0, and set properties
  set onsemi_python_cam_0 [ create_bd_cell -type ip -vlnv avnet:onsemi_vita:onsemi_vita_cam onsemi_python_cam_0 ]

  # Create instance: onsemi_python_spi_0, and set properties
  set onsemi_python_spi_0 [ create_bd_cell -type ip -vlnv avnet:onsemi_vita:onsemi_vita_spi onsemi_python_spi_0 ]


  # Create instance: zynq_ultra_ps_e_0, and set properties
  #set zynq_ultra_ps_e_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:zynq_ultra_ps_e zynq_ultra_ps_e_0 ]
  set zynq_ultra_ps_e_0 [get_bd_cells zynq_ultra_ps_e_0]

  # report_property $zynq_ultra_ps_e_0
  set_property -dict [list CONFIG.PSU__FPGA_PL0_ENABLE {1}] [get_bd_cells zynq_ultra_ps_e_0]
  set_property -dict [list CONFIG.PSU__CRL_APB__PL0_REF_CTRL__SRCSEL {IOPLL}] [get_bd_cells zynq_ultra_ps_e_0]
  set_property -dict [list CONFIG.PSU__CRL_APB__PL0_REF_CTRL__FREQMHZ {75}] [get_bd_cells zynq_ultra_ps_e_0]
  set_property -dict [list CONFIG.PSU__FPGA_PL1_ENABLE {1}] [get_bd_cells zynq_ultra_ps_e_0]
  set_property -dict [list CONFIG.PSU__CRL_APB__PL1_REF_CTRL__SRCSEL {IOPLL}] [get_bd_cells zynq_ultra_ps_e_0]
  set_property -dict [list CONFIG.PSU__CRL_APB__PL1_REF_CTRL__FREQMHZ {150}] [get_bd_cells zynq_ultra_ps_e_0]
  set_property -dict [list CONFIG.PSU__FPGA_PL2_ENABLE {1}] [get_bd_cells zynq_ultra_ps_e_0]
  set_property -dict [list CONFIG.PSU__CRL_APB__PL2_REF_CTRL__SRCSEL {IOPLL}] [get_bd_cells zynq_ultra_ps_e_0]
  set_property -dict [list CONFIG.PSU__CRL_APB__PL2_REF_CTRL__FREQMHZ {200}] [get_bd_cells zynq_ultra_ps_e_0]
  set_property -dict [list CONFIG.PSU__NUM_FABRIC_RESETS {3}] [get_bd_cells zynq_ultra_ps_e_0]

  # Create instance: processing_system7_0_axi_periph, and set properties
  set processing_system7_0_axi_periph [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect processing_system7_0_axi_periph ]
  set_property -dict [ list \
CONFIG.NUM_MI {7} \
 ] $processing_system7_0_axi_periph

  # Create instance: rst_processing_system7_0_148_5M, and set properties
  set rst_processing_system7_0_148_5M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset rst_processing_system7_0_148_5M ]

  # Create instance: rst_processing_system7_0_149M, and set properties
  set rst_processing_system7_0_149M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset rst_processing_system7_0_149M ]

  # Create instance: rst_processing_system7_0_76M, and set properties
  set rst_processing_system7_0_76M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset rst_processing_system7_0_76M ]

  # Create instance: v_axi4s_vid_out_0, and set properties
  set v_axi4s_vid_out_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_axi4s_vid_out v_axi4s_vid_out_0 ]
  set_property -dict [ list \
CONFIG.C_HAS_ASYNC_CLK {1} \
CONFIG.C_VTG_MASTER_SLAVE {1} \
 ] $v_axi4s_vid_out_0

  # Create instance: v_cfa_0, and set properties
  #set v_cfa_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_cfa v_cfa_0 ]
  set v_cfa_0 [get_bd_cells v_cfa_0]
  set_property -dict [ list \
CONFIG.active_cols {1280} \
CONFIG.active_rows {1024} \
CONFIG.has_axi4_lite {true} \
CONFIG.max_cols {1280} \
 ] $v_cfa_0

  # Create instance: v_cresample_0, and set properties
  #set v_cresample_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_cresample v_cresample_0 ]
  set v_cresample_0 [get_bd_cells v_cresample_0]
  set_property -dict [ list \
CONFIG.active_cols {1280} \
CONFIG.active_rows {1024} \
CONFIG.m_axis_video_format {2} \
CONFIG.s_axis_video_format {3} \
 ] $v_cresample_0

  # Create instance: v_osd_0, and set properties
  #set v_osd_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_osd v_osd_0 ]
  set v_osd_0 [get_bd_cells v_osd_0]
  set_property -dict [ list \
CONFIG.LAYER0_GLOBAL_ALPHA_ENABLE {true} \
CONFIG.LAYER0_GLOBAL_ALPHA_VALUE {256} \
CONFIG.LAYER0_HEIGHT {1080} \
CONFIG.LAYER0_WIDTH {1920} \
CONFIG.LAYER1_GLOBAL_ALPHA_ENABLE {true} \
CONFIG.LAYER1_GLOBAL_ALPHA_VALUE {256} \
CONFIG.LAYER1_HEIGHT {1080} \
CONFIG.LAYER1_WIDTH {1920} \
CONFIG.LAYER2_GLOBAL_ALPHA_VALUE {256} \
CONFIG.LAYER2_PRIORITY {1} \
CONFIG.LAYER3_GLOBAL_ALPHA_VALUE {256} \
CONFIG.LAYER3_PRIORITY {1} \
CONFIG.LAYER4_GLOBAL_ALPHA_VALUE {256} \
CONFIG.LAYER4_PRIORITY {1} \
CONFIG.LAYER5_GLOBAL_ALPHA_VALUE {256} \
CONFIG.LAYER5_PRIORITY {1} \
CONFIG.LAYER6_GLOBAL_ALPHA_VALUE {256} \
CONFIG.LAYER6_PRIORITY {1} \
CONFIG.LAYER7_GLOBAL_ALPHA_VALUE {256} \
CONFIG.LAYER7_PRIORITY {1} \
CONFIG.M_AXIS_VIDEO_HEIGHT {1080} \
CONFIG.M_AXIS_VIDEO_WIDTH {1920} \
CONFIG.NUMBER_OF_LAYERS {2} \
CONFIG.SCREEN_WIDTH {1920} \
 ] $v_osd_0

  # Need to retain value_src of defaults
  set_property -dict [ list \
CONFIG.LAYER0_GLOBAL_ALPHA_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.LAYER0_GLOBAL_ALPHA_VALUE.VALUE_SRC {DEFAULT} \
CONFIG.LAYER1_GLOBAL_ALPHA_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.LAYER1_GLOBAL_ALPHA_VALUE.VALUE_SRC {DEFAULT} \
CONFIG.LAYER2_GLOBAL_ALPHA_VALUE.VALUE_SRC {DEFAULT} \
CONFIG.LAYER2_PRIORITY.VALUE_SRC {DEFAULT} \
CONFIG.LAYER3_GLOBAL_ALPHA_VALUE.VALUE_SRC {DEFAULT} \
CONFIG.LAYER3_PRIORITY.VALUE_SRC {DEFAULT} \
CONFIG.LAYER4_GLOBAL_ALPHA_VALUE.VALUE_SRC {DEFAULT} \
CONFIG.LAYER4_PRIORITY.VALUE_SRC {DEFAULT} \
CONFIG.LAYER5_GLOBAL_ALPHA_VALUE.VALUE_SRC {DEFAULT} \
CONFIG.LAYER5_PRIORITY.VALUE_SRC {DEFAULT} \
CONFIG.LAYER6_GLOBAL_ALPHA_VALUE.VALUE_SRC {DEFAULT} \
CONFIG.LAYER6_PRIORITY.VALUE_SRC {DEFAULT} \
CONFIG.LAYER7_GLOBAL_ALPHA_VALUE.VALUE_SRC {DEFAULT} \
CONFIG.LAYER7_PRIORITY.VALUE_SRC {DEFAULT} \
 ] $v_osd_0

  # Create instance: v_rgb2ycrcb_0, and set properties
  #set v_rgb2ycrcb_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_rgb2ycrcb v_rgb2ycrcb_0 ]
  set v_rgb2ycrcb_0 [get_bd_cells v_rgb2ycrcb_0]
  set_property -dict [ list \
CONFIG.ACTIVE_COLS {1280} \
CONFIG.ACTIVE_ROWS {1024} \
 ] $v_rgb2ycrcb_0

  # Create instance: v_tc_0, and set properties
  #set v_tc_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_tc v_tc_0 ]
  set v_tc_0 [get_bd_cells v_tc_0]
  set_property -dict [ list \
CONFIG.HAS_AXI4_LITE {false} \
CONFIG.VIDEO_MODE {1080p} \
CONFIG.enable_detection {false} \
 ] $v_tc_0

  # Create instance: v_vid_in_axi4s_0, and set properties
  set v_vid_in_axi4s_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_vid_in_axi4s v_vid_in_axi4s_0 ]
  set_property -dict [ list \
CONFIG.C_HAS_ASYNC_CLK {1} \
CONFIG.C_M_AXIS_VIDEO_FORMAT {12} \
 ] $v_vid_in_axi4s_0

  # Create instance: v_vid_in_axi4s_1, and set properties
  set v_vid_in_axi4s_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_vid_in_axi4s v_vid_in_axi4s_1 ]
  set_property -dict [ list \
CONFIG.C_HAS_ASYNC_CLK {1} \
CONFIG.C_M_AXIS_VIDEO_FORMAT {0} \
 ] $v_vid_in_axi4s_1

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant xlconstant_0 ]
  set_property -dict [ list \
CONFIG.CONST_VAL {0} \
 ] $xlconstant_0

  # Create instance: xlconstant_1, and set properties
  set xlconstant_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant xlconstant_1 ]

  # Create interface connections
  connect_bd_intf_net -intf_net IO_CAM_IN_1 [get_bd_intf_ports IO_PYTHON_CAM] [get_bd_intf_pins onsemi_python_cam_0/IO_CAM_IN]
  connect_bd_intf_net -intf_net IO_HDMII_1 [get_bd_intf_ports IO_HDMII] [get_bd_intf_pins avnet_hdmi_in_0/IO_HDMII]
  connect_bd_intf_net -intf_net avnet_hdmi_in_0_VID_IO_OUT [get_bd_intf_pins avnet_hdmi_in_0/VID_IO_OUT] [get_bd_intf_pins v_vid_in_axi4s_1/vid_io_in]
  connect_bd_intf_net -intf_net avnet_hdmi_out_0_IO_HDMIO [get_bd_intf_ports IO_HDMIO] [get_bd_intf_pins avnet_hdmi_out_0/IO_HDMIO]
  #connect_bd_intf_net -intf_net axi_mem_intercon_M00_AXI [get_bd_intf_pins axi_mem_intercon/M00_AXI] [get_bd_intf_pins zynq_ultra_ps_e_0/S_AXI_HP0]
  connect_bd_intf_net -intf_net axi_mem_intercon_M00_AXI [get_bd_intf_pins axi_mem_intercon/M00_AXI] [get_bd_intf_pins zynq_ultra_ps_e_0/S_AXI_HP0_FPD]
  connect_bd_intf_net -intf_net axi_vdma_0_M_AXIS_MM2S [get_bd_intf_pins axi_vdma_0/M_AXIS_MM2S] [get_bd_intf_pins v_osd_0/video_s0_in]
  connect_bd_intf_net -intf_net axi_vdma_0_M_AXI_MM2S [get_bd_intf_pins axi_mem_intercon/S00_AXI] [get_bd_intf_pins axi_vdma_0/M_AXI_MM2S]
  connect_bd_intf_net -intf_net axi_vdma_0_M_AXI_S2MM [get_bd_intf_pins axi_mem_intercon/S01_AXI] [get_bd_intf_pins axi_vdma_0/M_AXI_S2MM]
  connect_bd_intf_net -intf_net axi_vdma_1_M_AXIS_MM2S [get_bd_intf_pins axi_vdma_1/M_AXIS_MM2S] [get_bd_intf_pins v_osd_0/video_s1_in]
  connect_bd_intf_net -intf_net axi_vdma_1_M_AXI_MM2S [get_bd_intf_pins axi_mem_intercon/S02_AXI] [get_bd_intf_pins axi_vdma_1/M_AXI_MM2S]
  connect_bd_intf_net -intf_net axi_vdma_1_M_AXI_S2MM [get_bd_intf_pins axi_mem_intercon/S03_AXI] [get_bd_intf_pins axi_vdma_1/M_AXI_S2MM]
  connect_bd_intf_net -intf_net fmc_hdmi_cam_iic_0_IIC [get_bd_intf_ports fmc_hdmi_cam_iic] [get_bd_intf_pins fmc_hdmi_cam_iic_0/IIC]
  connect_bd_intf_net -intf_net onsemi_python_cam_0_VID_IO_OUT [get_bd_intf_pins onsemi_python_cam_0/VID_IO_OUT] [get_bd_intf_pins v_vid_in_axi4s_0/vid_io_in]
  connect_bd_intf_net -intf_net onsemi_python_spi_0_IO_SPI_OUT [get_bd_intf_ports IO_PYTHON_SPI] [get_bd_intf_pins onsemi_python_spi_0/IO_SPI_OUT]
  #connect_bd_intf_net -intf_net processing_system7_0_DDR [get_bd_intf_ports DDR] [get_bd_intf_pins zynq_ultra_ps_e_0/DDR]
  #connect_bd_intf_net -intf_net processing_system7_0_FIXED_IO [get_bd_intf_ports FIXED_IO] [get_bd_intf_pins zynq_ultra_ps_e_0/FIXED_IO]
  #connect_bd_intf_net -intf_net processing_system7_0_M_AXI_GP0 [get_bd_intf_pins zynq_ultra_ps_e_0/M_AXI_GP0] [get_bd_intf_pins processing_system7_0_axi_periph/S00_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_M_AXI_GP0 [get_bd_intf_pins zynq_ultra_ps_e_0/M_AXI_HPM0_FPD] [get_bd_intf_pins processing_system7_0_axi_periph/S00_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M00_AXI [get_bd_intf_pins fmc_hdmi_cam_iic_0/S_AXI] [get_bd_intf_pins processing_system7_0_axi_periph/M00_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M01_AXI [get_bd_intf_pins axi_vdma_0/S_AXI_LITE] [get_bd_intf_pins processing_system7_0_axi_periph/M01_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M02_AXI [get_bd_intf_pins processing_system7_0_axi_periph/M02_AXI] [get_bd_intf_pins v_osd_0/ctrl]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M03_AXI [get_bd_intf_pins onsemi_python_cam_0/S00_AXI] [get_bd_intf_pins processing_system7_0_axi_periph/M03_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M04_AXI [get_bd_intf_pins processing_system7_0_axi_periph/M04_AXI] [get_bd_intf_pins v_cfa_0/ctrl]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M05_AXI [get_bd_intf_pins axi_vdma_1/S_AXI_LITE] [get_bd_intf_pins processing_system7_0_axi_periph/M05_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M06_AXI [get_bd_intf_pins onsemi_python_spi_0/S00_AXI] [get_bd_intf_pins processing_system7_0_axi_periph/M06_AXI]
  connect_bd_intf_net -intf_net v_axi4s_vid_out_0_vid_io_out [get_bd_intf_pins avnet_hdmi_out_0/VID_IO_IN] [get_bd_intf_pins v_axi4s_vid_out_0/vid_io_out]
  connect_bd_intf_net -intf_net v_cfa_0_video_out [get_bd_intf_pins v_cfa_0/video_out] [get_bd_intf_pins v_rgb2ycrcb_0/video_in]
  connect_bd_intf_net -intf_net v_cresample_0_video_out [get_bd_intf_pins axi_vdma_1/S_AXIS_S2MM] [get_bd_intf_pins v_cresample_0/video_out]
  connect_bd_intf_net -intf_net v_osd_0_video_out [get_bd_intf_pins v_axi4s_vid_out_0/video_in] [get_bd_intf_pins v_osd_0/video_out]
  connect_bd_intf_net -intf_net v_rgb2ycrcb_0_video_out [get_bd_intf_pins v_cresample_0/video_in] [get_bd_intf_pins v_rgb2ycrcb_0/video_out]
  connect_bd_intf_net -intf_net v_tc_0_vtiming_out [get_bd_intf_pins v_axi4s_vid_out_0/vtiming_in] [get_bd_intf_pins v_tc_0/vtiming_out]
  connect_bd_intf_net -intf_net v_vid_in_axi4s_0_video_out [get_bd_intf_pins v_cfa_0/video_in] [get_bd_intf_pins v_vid_in_axi4s_0/video_out]
  connect_bd_intf_net -intf_net v_vid_in_axi4s_1_video_out [get_bd_intf_pins axi_vdma_0/S_AXIS_S2MM] [get_bd_intf_pins v_vid_in_axi4s_1/video_out]

  # Create port connections
  #connect_bd_net -net M_AXI_GP0_ACLK_1 [get_bd_ports M_AXI_GP0_ACLK]
  connect_bd_net -net avnet_hdmi_in_0_audio_spdif [get_bd_pins avnet_hdmi_in_0/audio_spdif] [get_bd_pins avnet_hdmi_out_0/audio_spdif]
  connect_bd_net -net avnet_hdmi_in_0_hdmii_clk [get_bd_pins avnet_hdmi_in_0/hdmii_clk] [get_bd_pins v_vid_in_axi4s_1/vid_io_in_clk]
  connect_bd_net -net clk_wiz_0_clk_out1 [get_bd_pins avnet_hdmi_out_0/clk] [get_bd_pins clk_wiz_0/clk_out1] [get_bd_pins rst_processing_system7_0_148_5M/slowest_sync_clk] [get_bd_pins v_axi4s_vid_out_0/vid_io_out_clk] [get_bd_pins v_tc_0/clk]
  connect_bd_net -net clk_wiz_0_clk_out2 [get_bd_pins clk_wiz_0/clk_out2] [get_bd_pins onsemi_python_cam_0/clk] [get_bd_pins v_vid_in_axi4s_0/vid_io_in_clk]
  connect_bd_net -net fmc_hdmi_cam_iic_0_gpo [get_bd_ports fmc_hdmi_cam_iic_rst_n] [get_bd_pins fmc_hdmi_cam_iic_0/gpo]
  connect_bd_net -net fmc_hdmi_cam_vclk_1 [get_bd_ports fmc_hdmi_cam_vclk] [get_bd_pins clk_wiz_0/clk_in1]
  connect_bd_net -net zynq_ultra_ps_e_0_pl_clk0 [get_bd_pins axi_vdma_0/s_axi_lite_aclk] [get_bd_pins zynq_ultra_ps_e_0/maxihpm0_fpd_aclk] [get_bd_pins zynq_ultra_ps_e_0/maxihpm1_fpd_aclk]
  connect_bd_net -net zynq_ultra_ps_e_0_pl_clk0 [get_bd_pins axi_vdma_1/s_axi_lite_aclk] [get_bd_pins fmc_hdmi_cam_iic_0/s_axi_aclk] [get_bd_pins onsemi_python_cam_0/s00_axi_aclk] [get_bd_pins onsemi_python_spi_0/s00_axi_aclk] [get_bd_pins zynq_ultra_ps_e_0/pl_clk0] [get_bd_pins zynq_ultra_ps_e_0/M_AXI_GP0_ACLK] [get_bd_pins processing_system7_0_axi_periph/ACLK] [get_bd_pins processing_system7_0_axi_periph/M00_ACLK] [get_bd_pins processing_system7_0_axi_periph/M01_ACLK] [get_bd_pins processing_system7_0_axi_periph/M02_ACLK] [get_bd_pins processing_system7_0_axi_periph/M03_ACLK] [get_bd_pins processing_system7_0_axi_periph/M04_ACLK] [get_bd_pins processing_system7_0_axi_periph/M05_ACLK] [get_bd_pins processing_system7_0_axi_periph/M06_ACLK] [get_bd_pins processing_system7_0_axi_periph/S00_ACLK] [get_bd_pins rst_processing_system7_0_76M/slowest_sync_clk] [get_bd_pins v_cfa_0/s_axi_aclk] [get_bd_pins v_osd_0/s_axi_aclk]
  connect_bd_net -net zynq_ultra_ps_e_0_pl_clk1 [get_bd_pins axi_mem_intercon/ACLK] [get_bd_pins axi_mem_intercon/M00_ACLK] [get_bd_pins axi_mem_intercon/S00_ACLK] [get_bd_pins axi_mem_intercon/S01_ACLK] [get_bd_pins axi_mem_intercon/S02_ACLK] [get_bd_pins axi_mem_intercon/S03_ACLK] [get_bd_pins axi_vdma_0/m_axi_mm2s_aclk] [get_bd_pins axi_vdma_0/m_axi_s2mm_aclk] [get_bd_pins axi_vdma_0/m_axis_mm2s_aclk] [get_bd_pins axi_vdma_0/s_axis_s2mm_aclk] [get_bd_pins axi_vdma_1/m_axi_mm2s_aclk] [get_bd_pins axi_vdma_1/m_axi_s2mm_aclk] [get_bd_pins axi_vdma_1/m_axis_mm2s_aclk] [get_bd_pins axi_vdma_1/s_axis_s2mm_aclk] [get_bd_pins zynq_ultra_ps_e_0/pl_clk1] [get_bd_pins zynq_ultra_ps_e_0/S_AXI_HP0_ACLK] [get_bd_pins rst_processing_system7_0_149M/slowest_sync_clk] [get_bd_pins v_axi4s_vid_out_0/aclk] [get_bd_pins v_cfa_0/aclk] [get_bd_pins v_cresample_0/aclk] [get_bd_pins v_osd_0/aclk] [get_bd_pins v_rgb2ycrcb_0/aclk] [get_bd_pins v_vid_in_axi4s_0/aclk] [get_bd_pins v_vid_in_axi4s_1/aclk]
  connect_bd_net -net zynq_ultra_ps_e_0_pl_clk1 [get_bd_pins zynq_ultra_ps_e_0/saxihp0_fpd_aclk]
  connect_bd_net -net zynq_ultra_ps_e_0_pl_clk2 [get_bd_pins onsemi_python_cam_0/clk200] [get_bd_pins zynq_ultra_ps_e_0/pl_clk2]
  connect_bd_net -net processing_system7_0_FCLK_RESET0_N [get_bd_pins zynq_ultra_ps_e_0/pl_resetn0] [get_bd_pins rst_processing_system7_0_76M/ext_reset_in]
  connect_bd_net -net processing_system7_0_FCLK_RESET1_N [get_bd_pins zynq_ultra_ps_e_0/pl_resetn1] [get_bd_pins rst_processing_system7_0_149M/ext_reset_in]
  connect_bd_net -net processing_system7_0_FCLK_RESET2_N [get_bd_pins zynq_ultra_ps_e_0/pl_resetn2] [get_bd_pins rst_processing_system7_0_148_5M/ext_reset_in]
  connect_bd_net -net rst_processing_system7_0_148_5M_peripheral_aresetn [get_bd_pins rst_processing_system7_0_148_5M/peripheral_aresetn] [get_bd_pins v_tc_0/resetn]
  connect_bd_net -net rst_processing_system7_0_148_5M_peripheral_reset [get_bd_pins onsemi_python_cam_0/reset] [get_bd_pins rst_processing_system7_0_148_5M/peripheral_reset]
  connect_bd_net -net rst_processing_system7_0_149M_interconnect_aresetn [get_bd_pins axi_mem_intercon/ARESETN] [get_bd_pins rst_processing_system7_0_149M/interconnect_aresetn]
  connect_bd_net -net rst_processing_system7_0_149M_peripheral_aresetn [get_bd_pins axi_mem_intercon/M00_ARESETN] [get_bd_pins axi_mem_intercon/S00_ARESETN] [get_bd_pins axi_mem_intercon/S01_ARESETN] [get_bd_pins axi_mem_intercon/S02_ARESETN] [get_bd_pins axi_mem_intercon/S03_ARESETN] [get_bd_pins rst_processing_system7_0_149M/peripheral_aresetn] [get_bd_pins v_cfa_0/aresetn] [get_bd_pins v_cresample_0/aresetn] [get_bd_pins v_osd_0/aresetn] [get_bd_pins v_rgb2ycrcb_0/aresetn]
  connect_bd_net -net rst_processing_system7_0_76M_interconnect_aresetn [get_bd_pins processing_system7_0_axi_periph/ARESETN] [get_bd_pins rst_processing_system7_0_76M/interconnect_aresetn]
  connect_bd_net -net rst_processing_system7_0_76M_peripheral_aresetn [get_bd_pins axi_vdma_0/axi_resetn] [get_bd_pins axi_vdma_1/axi_resetn] [get_bd_pins fmc_hdmi_cam_iic_0/s_axi_aresetn] [get_bd_pins onsemi_python_cam_0/s00_axi_aresetn] [get_bd_pins onsemi_python_spi_0/s00_axi_aresetn] [get_bd_pins processing_system7_0_axi_periph/M00_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M01_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M02_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M03_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M04_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M05_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M06_ARESETN] [get_bd_pins processing_system7_0_axi_periph/S00_ARESETN] [get_bd_pins rst_processing_system7_0_76M/peripheral_aresetn] [get_bd_pins v_axi4s_vid_out_0/aresetn] [get_bd_pins v_cfa_0/s_axi_aresetn] [get_bd_pins v_osd_0/s_axi_aresetn] [get_bd_pins v_vid_in_axi4s_0/aresetn]
  connect_bd_net -net rst_processing_system7_0_76M_peripheral_reset [get_bd_pins avnet_hdmi_out_0/reset] [get_bd_pins rst_processing_system7_0_76M/peripheral_reset] [get_bd_pins v_axi4s_vid_out_0/vid_io_out_reset] [get_bd_pins v_vid_in_axi4s_0/vid_io_in_reset]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins onsemi_python_cam_0/trigger1] [get_bd_pins v_vid_in_axi4s_1/vid_io_in_reset] [get_bd_pins xlconstant_0/dout]
  connect_bd_net -net xlconstant_1_dout [get_bd_pins avnet_hdmi_out_0/embed_syncs] [get_bd_pins avnet_hdmi_out_0/oe] [get_bd_pins onsemi_python_cam_0/oe] [get_bd_pins onsemi_python_spi_0/oe] [get_bd_pins v_axi4s_vid_out_0/aclken] [get_bd_pins v_axi4s_vid_out_0/vid_io_out_ce] [get_bd_pins v_cfa_0/aclken] [get_bd_pins v_cfa_0/s_axi_aclken] [get_bd_pins v_cresample_0/aclken] [get_bd_pins v_osd_0/aclken] [get_bd_pins v_osd_0/s_axi_aclken] [get_bd_pins v_rgb2ycrcb_0/aclken] [get_bd_pins v_tc_0/clken] [get_bd_pins v_tc_0/gen_clken] [get_bd_pins v_vid_in_axi4s_0/aclken] [get_bd_pins v_vid_in_axi4s_0/axis_enable] [get_bd_pins v_vid_in_axi4s_0/vid_io_in_ce] [get_bd_pins v_vid_in_axi4s_1/aclken] [get_bd_pins v_vid_in_axi4s_1/aresetn] [get_bd_pins v_vid_in_axi4s_1/axis_enable] [get_bd_pins v_vid_in_axi4s_1/vid_io_in_ce] [get_bd_pins xlconstant_1/dout]

  if (0) {
  apply_bd_automation -rule xilinx.com:bd_rule:clkrst -config {Clk "/zynq_ultra_ps_e_0/pl_clk0 (100 MHz)" }  [get_bd_pins axi_mem_intercon/ACLK]
  apply_bd_automation -rule xilinx.com:bd_rule:clkrst -config {Clk "/zynq_ultra_ps_e_0/pl_clk0 (100 MHz)" }  [get_bd_pins axi_vdma_0/s_axi_lite_aclk]
  apply_bd_automation -rule xilinx.com:bd_rule:clkrst -config {Clk "/zynq_ultra_ps_e_0/pl_clk0 (100 MHz)" }  [get_bd_pins zynq_ultra_ps_e_0/maxihpm0_fpd_aclk]
  apply_bd_automation -rule xilinx.com:bd_rule:clkrst -config {Clk "/zynq_ultra_ps_e_0/pl_clk0 (100 MHz)" }  [get_bd_pins zynq_ultra_ps_e_0/saxihp0_fpd_aclk]
  apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Clk_master {Auto} Clk_slave {/zynq_ultra_ps_e_0/pl_clk0 (100 MHz)} Clk_xbar {/zynq_ultra_ps_e_0/pl_clk0 (100 MHz)} Master {/zynq_ultra_ps_e_0/M_AXI_HPM1_FPD} Slave {/fmc_hdmi_cam_iic_0/S_AXI} intc_ip {/processing_system7_0_axi_periph} master_apm {0}}  [get_bd_intf_pins zynq_ultra_ps_e_0/M_AXI_HPM1_FPD]
  }

  if (0) {
  #apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Clk_master {Auto} Clk_slave {/zynq_ultra_ps_e_0/pl_clk0 (100 MHz)} Clk_xbar {/zynq_ultra_ps_e_0/pl_clk0 (100 MHz)} Master {/zynq_ultra_ps_e_0/M_AXI_HPM1_FPD} Slave {/fmc_hdmi_cam_iic_0/S_AXI} intc_ip {/processing_system7_0_axi_periph} master_apm {0}}  [get_bd_intf_pins zynq_ultra_ps_e_0/M_AXI_HPM1_FPD]
  apply_bd_automation -rule xilinx.com:bd_rule:clkrst -config {Clk "/zynq_ultra_ps_e_0/pl_clk0 (100 MHz)" }  [get_bd_pins zynq_ultra_ps_e_0/maxihpm0_fpd_aclk]
  apply_bd_automation -rule xilinx.com:bd_rule:clkrst -config {Clk "/zynq_ultra_ps_e_0/pl_clk0 (100 MHz)" }  [get_bd_pins zynq_ultra_ps_e_0/saxihp0_fpd_aclk]
  }

  if (0) {
  # Create address segments
  #create_bd_addr_seg -range 0x20000000 -offset 0x00000000 [get_bd_addr_spaces axi_vdma_0/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/S_AXI_HP0_FPD/HP0_DDR_LOW] SEG_processing_system7_0_HP0_DDR_LOWOCM
  #create_bd_addr_seg -range 0x20000000 -offset 0x00000000 [get_bd_addr_spaces axi_vdma_0/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/S_AXI_HP0_FPD/HP0_DDR_LOW] SEG_processing_system7_0_HP0_DDR_LOWOCM
  #create_bd_addr_seg -range 0x20000000 -offset 0x00000000 [get_bd_addr_spaces axi_vdma_1/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/S_AXI_HP0_FPD/HP0_DDR_LOW] SEG_processing_system7_0_HP0_DDR_LOWOCM
  #create_bd_addr_seg -range 0x20000000 -offset 0x00000000 [get_bd_addr_spaces axi_vdma_1/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/S_AXI_HP0_FPD/HP0_DDR_LOW] SEG_processing_system7_0_HP0_DDR_LOWOCM
  create_bd_addr_seg -range 0x00010000 -offset 0x43000000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_vdma_0/S_AXI_LITE/Reg] SEG_axi_vdma_0_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x43010000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_vdma_1/S_AXI_LITE/Reg] SEG_axi_vdma_1_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x41600000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs fmc_hdmi_cam_iic_0/S_AXI/Reg] SEG_fmc_hdmi_cam_iic_0_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x43C20000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs onsemi_python_cam_0/S00_AXI/Reg] SEG_onsemi_python_cam_0_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x43C40000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs onsemi_python_spi_0/S00_AXI/Reg] SEG_onsemi_python_spi_0_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x43C30000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs v_cfa_0/ctrl/Reg] SEG_v_cfa_0_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x43C10000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs v_osd_0/ctrl/Reg] SEG_v_osd_0_Reg
  }

  # Perform GUI Layout
  regenerate_bd_layout -layout_string {
   guistr: "# # String gsaved with Nlview 6.6.5b  2016-09-06 bk=1.3687 VDI=39 GEI=35 GUI=JA:1.6
#  -string -flagsOSRD
preplace port IO_PYTHON_SPI -pg 1 -y 930 -defaultsOSRD
preplace port DDR -pg 1 -y 40 -defaultsOSRD
preplace port IO_HDMIO -pg 1 -y 730 -defaultsOSRD
preplace port M_AXI_GP0_ACLK -pg 1 -y 20 -defaultsOSRD
preplace port fmc_hdmi_cam_iic -pg 1 -y 1080 -defaultsOSRD
preplace port IO_PYTHON_CAM -pg 1 -y 1090 -defaultsOSRD
preplace port FIXED_IO -pg 1 -y 60 -defaultsOSRD
preplace port fmc_hdmi_cam_vclk -pg 1 -y 1020 -defaultsOSRD
preplace port IO_HDMII -pg 1 -y 790 -defaultsOSRD
preplace portBus fmc_hdmi_cam_iic_rst_n -pg 1 -y 1120 -defaultsOSRD
preplace inst avnet_hdmi_in_0 -pg 1 -lvl 1 -y 790 -defaultsOSRD
preplace inst v_axi4s_vid_out_0 -pg 1 -lvl 14 -y 740 -defaultsOSRD
preplace inst rst_processing_system7_0_76M -pg 1 -lvl 2 -y 650 -defaultsOSRD
preplace inst axi_vdma_0 -pg 1 -lvl 3 -y 870 -defaultsOSRD
preplace inst v_tc_0 -pg 1 -lvl 13 -y 990 -defaultsOSRD
preplace inst xlconstant_0 -pg 1 -lvl 1 -y 970 -defaultsOSRD
preplace inst axi_vdma_1 -pg 1 -lvl 12 -y 720 -defaultsOSRD
preplace inst v_cfa_0 -pg 1 -lvl 9 -y 910 -defaultsOSRD
preplace inst xlconstant_1 -pg 1 -lvl 1 -y 890 -defaultsOSRD
preplace inst rst_processing_system7_0_148_5M -pg 1 -lvl 6 -y 930 -defaultsOSRD
preplace inst onsemi_python_cam_0 -pg 1 -lvl 7 -y 1150 -defaultsOSRD
preplace inst fmc_hdmi_cam_iic_0 -pg 1 -lvl 15 -y 1100 -defaultsOSRD
preplace inst v_osd_0 -pg 1 -lvl 13 -y 670 -defaultsOSRD
preplace inst v_cresample_0 -pg 1 -lvl 11 -y 960 -defaultsOSRD
preplace inst rst_processing_system7_0_149M -pg 1 -lvl 3 -y 270 -defaultsOSRD
preplace inst v_vid_in_axi4s_0 -pg 1 -lvl 8 -y 900 -defaultsOSRD
preplace inst onsemi_python_spi_0 -pg 1 -lvl 15 -y 930 -defaultsOSRD
preplace inst v_vid_in_axi4s_1 -pg 1 -lvl 2 -y 860 -defaultsOSRD
preplace inst clk_wiz_0 -pg 1 -lvl 5 -y 1020 -defaultsOSRD
preplace inst v_rgb2ycrcb_0 -pg 1 -lvl 10 -y 930 -defaultsOSRD
preplace inst avnet_hdmi_out_0 -pg 1 -lvl 15 -y 740 -defaultsOSRD
preplace inst axi_mem_intercon -pg 1 -lvl 4 -y 600 -defaultsOSRD
preplace inst processing_system7_0_axi_periph -pg 1 -lvl 6 -y 310 -defaultsOSRD
preplace inst zynq_ultra_ps_e_0 -pg 1 -lvl 5 -y 170 -defaultsOSRD
preplace netloc processing_system7_0_DDR 1 5 11 NJ 40 NJ 40 NJ 40 NJ 40 NJ 40 NJ 40 NJ 40 NJ 40 NJ 40 NJ 40 NJ
preplace netloc xlconstant_1_dout 1 1 14 260 1090 NJ 1090 NJ 1090 NJ 1090 NJ 1090 2220 960 2570 1090 2880 1090 3110 1090 3340 1090 NJ 1090 4030 1090 4290 1090 4620
preplace netloc rst_processing_system7_0_149M_peripheral_aresetn 1 3 10 1020 830 1390J 750 NJ 750 NJ 750 NJ 750 2840 750 3100 750 3330 750 3590J 860 4020J
preplace netloc rst_processing_system7_0_149M_interconnect_aresetn 1 3 1 1030
preplace netloc v_vid_in_axi4s_0_video_out 1 8 1 N
preplace netloc axi_vdma_1_M_AXI_S2MM 1 3 10 1060 390 1330J 580 NJ 580 NJ 580 NJ 580 NJ 580 NJ 580 NJ 580 NJ 580 3960
preplace netloc avnet_hdmi_in_0_hdmii_clk 1 1 1 270
preplace netloc fmc_hdmi_cam_iic_0_IIC 1 15 1 NJ
preplace netloc processing_system7_0_axi_periph_M03_AXI 1 6 1 2260
preplace netloc processing_system7_0_axi_periph_M00_AXI 1 6 9 N 250 NJ 250 NJ 250 NJ 250 NJ 250 NJ 250 NJ 250 NJ 250 4600J
preplace netloc rst_processing_system7_0_76M_peripheral_aresetn 1 2 13 610 750 970J 820 NJ 820 1870 820 2210 210 2560 210 2870 210 NJ 210 NJ 210 3630 210 4010 210 4280 210 4580
preplace netloc v_axi4s_vid_out_0_vid_io_out 1 14 1 N
preplace netloc processing_system7_0_M_AXI_GP0 1 5 1 1880
preplace netloc axi_vdma_1_M_AXI_MM2S 1 3 10 1050 380 1340J 560 NJ 560 NJ 560 NJ 560 NJ 560 NJ 560 NJ 560 NJ 560 3970
preplace netloc axi_vdma_0_M_AXI_MM2S 1 3 1 980
preplace netloc processing_system7_0_axi_periph_M05_AXI 1 6 6 NJ 350 NJ 350 NJ 350 NJ 350 NJ 350 3610
preplace netloc axi_vdma_0_M_AXIS_MM2S 1 3 10 NJ 850 1370J 600 NJ 600 NJ 600 NJ 600 NJ 600 NJ 600 NJ 600 NJ 600 3980
preplace netloc processing_system7_0_FCLK_RESET0_N 1 1 5 260 360 NJ 360 NJ 360 NJ 360 1820
preplace netloc v_vid_in_axi4s_1_video_out 1 2 1 N
preplace netloc v_osd_0_video_out 1 13 1 N
preplace netloc v_cresample_0_video_out 1 11 1 3570
preplace netloc axi_mem_intercon_M00_AXI 1 4 1 1320
preplace netloc processing_system7_0_FCLK_RESET2_N 1 5 1 1840
preplace netloc processing_system7_0_axi_periph_M02_AXI 1 6 7 NJ 290 NJ 290 NJ 290 NJ 290 NJ 290 NJ 290 4030
preplace netloc processing_system7_0_FCLK_RESET1_N 1 2 4 640 180 NJ 180 1380J 350 1810
preplace netloc v_cfa_0_video_out 1 9 1 N
preplace netloc processing_system7_0_axi_periph_M06_AXI 1 6 9 N 370 NJ 370 NJ 370 NJ 370 NJ 370 NJ 370 NJ 370 NJ 370 4590J
preplace netloc axi_vdma_1_M_AXIS_MM2S 1 12 1 3980
preplace netloc xlconstant_0_dout 1 1 6 270 1190 NJ 1190 NJ 1190 NJ 1190 NJ 1190 NJ
preplace netloc processing_system7_0_FIXED_IO 1 5 11 NJ 60 NJ 60 NJ 60 NJ 60 NJ 60 NJ 60 NJ 60 NJ 60 NJ 60 NJ 60 NJ
preplace netloc rst_processing_system7_0_76M_peripheral_reset 1 2 13 N 650 990J 840 1380J 650 NJ 650 NJ 650 2580 650 NJ 650 NJ 650 NJ 650 3600J 870 NJ 870 4310 870 4560
preplace netloc clk_wiz_0_clk_out1 1 5 10 1860 730 NJ 730 NJ 730 NJ 730 NJ 730 NJ 730 3580J 960 4040 900 4300 900 4570
preplace netloc avnet_hdmi_out_0_IO_HDMIO 1 15 1 N
preplace netloc avnet_hdmi_in_0_VID_IO_OUT 1 1 1 280
preplace netloc rst_processing_system7_0_76M_interconnect_aresetn 1 2 4 NJ 670 970J 350 1370J 370 1860
preplace netloc fmc_hdmi_cam_iic_0_gpo 1 15 1 NJ
preplace netloc clk_wiz_0_clk_out2 1 5 3 NJ 1030 2270 850 N
preplace netloc v_rgb2ycrcb_0_video_out 1 10 1 N
preplace netloc onsemi_python_cam_0_VID_IO_OUT 1 7 1 2540
preplace netloc zynq_ultra_ps_e_0_pl_clk0 1 1 14 280 560 630 390 980J 320 1390 400 1880 570 2250 390 NJ 390 2860 390 NJ 390 NJ 390 3620 390 4000 390 NJ 390 4550
preplace netloc IO_HDMII_1 1 0 1 N
preplace netloc v_tc_0_vtiming_out 1 13 1 4260
preplace netloc axi_vdma_0_M_AXI_S2MM 1 3 1 1000
preplace netloc rst_processing_system7_0_148_5M_peripheral_reset 1 6 1 2230
preplace netloc rst_processing_system7_0_148_5M_peripheral_aresetn 1 6 7 NJ 970 2530J 1040 NJ 1040 NJ 1040 NJ 1040 NJ 1040 4040
preplace netloc zynq_ultra_ps_e_0_pl_clk1 1 1 13 280 980 620 400 1040 330 1360 710 1830 710 NJ 710 2550 710 2880 710 3110 710 3340 710 3610 840 3990 800 4270
preplace netloc fmc_hdmi_cam_vclk_1 1 0 5 NJ 1020 NJ 1020 NJ 1020 NJ 1020 NJ
preplace netloc M_AXI_GP0_ACLK_1 1 0 1 N
preplace netloc onsemi_python_spi_0_IO_SPI_OUT 1 15 1 NJ
preplace netloc IO_CAM_IN_1 1 0 7 20J 1080 NJ 1080 NJ 1080 NJ 1080 NJ 1080 NJ 1080 2240J
preplace netloc processing_system7_0_axi_periph_M04_AXI 1 6 3 NJ 330 NJ 330 2850
preplace netloc processing_system7_0_axi_periph_M01_AXI 1 2 5 640 370 NJ 370 1350J 550 NJ 550 2200
preplace netloc zynq_ultra_ps_e_0_pl_clk2 1 5 2 1850J 1110 N
preplace netloc avnet_hdmi_in_0_audio_spdif 1 1 14 260J 740 NJ 740 1010J 810 1340J 740 NJ 740 NJ 740 NJ 740 NJ 740 NJ 740 NJ 740 3560J 880 NJ 880 NJ 880 4610
levelinfo -pg 1 0 140 450 810 1190 1600 2040 2410 2720 2990 3230 3460 3800 4150 4430 4740 4880 -top 0 -bot 1280
",
}

  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


