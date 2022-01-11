#!/bin/bash
#Purpose:A menu for adb shell commands
#Date:2022/1/11

DEVICE_NAME='0123456789ABCDEF'
WARNING_MSG_1="Wrong Choice: Please choose the correct option"
WARNING_MSG_2="Connection Fail: Please check the connection of your device"

function menu_show(){
    echo 'Choise an option'
    echo '0. Exit'
    echo '1. Check Wifi MAC, BT MAC, MBSN, QSN, CSN, Wifi Region, CPU ID, MB Version(HW ID)'
    echo '2. Write QSN'
    echo '3. Write CSN'
    echo '4. Write WiFi Region'
    echo '5. Check Image version'
    echo '6. Print eMMC name, eMMC type, eMMC size, eMMC Manufacture ID'
    echo '7. Check DDR size, DDR ID'
    echo '8. Check PMIC information'
    echo '9. Check ID'
    echo '10. Power button'
    echo '11. 4 top cover buttons'
    echo '12. LED option'
    echo '13. I2S quality for 5 microphones'
    echo '14. Check MB/CB Thermal sensor temperature'
}

function menu_LED_num_show(){
    echo 'Select LED 123 or all off'
    echo '0. Exit'
    echo '1. LED 1'
    echo '2. LED 2'
    echo '3. LED 3'
    echo '4. LED all off'
}

function menu_LED_color_show(){
    echo 'Select a LED color or 0 to exit'
    echo '0. Exit';
    echo '1. Red'
    echo '2. Green'
    echo '3. Blue'
}
function menu_LED_onoff_show(){
    echo 'On or Off...'
    echo '0. OFF'
    echo '1. ON'
}

function check_out_of_index(){
    if [[ $1 -lt $2 || $1 -gt $3 ]];then
	echo 
	echo ${WARNING_MSG_1} >&2
	echo "Please Enter the number between $2 and $3"
	echo 
	return 1
    fi
}

function check_adb_devices(){
    echo 'Checking connection of device ..'
    echo 'Please wait ..'
    if ! (echo $(adb.exe devices) | grep ${DEVICE_NAME});then
	echo
	sleep 3
	echo ${WARNING_MSG_2}
	echo
	return 1
    fi
    return 0
}

#Check Wifi MAC, BT MAC, MBSN, QSN, CSN, Wifi Region, CPU ID, MB Version(HW ID)
function menu_option_1(){	
    #Check Wifi MAC
    echo -e "\nReady to Check WiFi MAC ... "
    adb.exe shell "mfgNvram r_wifi_mac"
    #Check BT MAC
    echo -e "\nReady to Check BT MAC ... "
    adb.exe shell "mfgNvram r_bt_mac"
    #Check MBSN
    echo -e "\nReady to Check MBSN ... "
    adb.exe shell "mfgNvram r_pcbasn"
    #Check QSN
    echo -e "\nReady to Check QSN ... "	
    adb.exe shell "mfgNvram r_qsn"
    #Check CSN
    echo -e "\nReady to Check CSN ... "
    adb.exe shell "mfgNvram r_csn"	
    #Check WiFi Region
    echo -e "\nReady to Check WiFi Region ... "
    adb.exe shell "mfgNvram r_wifi_cc"	
    #Check CPU ID
    echo -e "\nReady to Check CPU ID ... "
    adb.exe shell "cat /proc/cmdline | awk 'BEGIN{RS=\" \"; FS=\"=\"} /cpu_id/{print $2}'"	
    #Check MB Version(HW ID)
    echo -e "\nReady to Check MB Version(HW ID) ... "
    adb.exe shell "cat /proc/cmdline | awk 'BEGIN{RS=\" \"; FS=\"=\"} /board_rev/{print $2}'"
}

#Write QSN
function menu_option_2(){
    echo -e "\nReady to Write QSN ... "
    read -p "Please enter the correct QSN: " QSN
    adb.exe shell "mfgNvram w_qsn ${QSN}"
}

#Write CSN
function menu_option_3(){
    echo -e "\nReady to Write CSN ... "
    read -p "Please enter the correct CSN: " CSN
    adb.exe shell "mfgNvram w_csn ${CSN}"
}

#Write WiFi Region
function menu_option_4(){
    echo -e "\nReady to Write WiFi Region ... "
    read -p "Please enter the correct COUNTRY_CODE: " COUNTRY_CODE 
    adb.exe shell "mfgNvram w_wifi_cc ${COUNTRY_CODE}"
}

#Check Image version
function menu_option_5(){
    echo -e "\nReady to Check Image version ... "
    adb.exe shell getprop ro.build.id
}

#eMMC name, eMMC type, eMMc size, eMMC Manufacture ID
function menu_option_6(){	
    #eMMC name
    echo -e "\nReady to print eMMC name ... "
    adb.exe shell cat /sys/bus/mmc/devices/mmc0\:0001/name
    #eMMC type
    echo -e "\nReady to print eMMC type ... "
    adb.exe shell cat /sys/bus/mmc/devices/mmc0\:0001/type
    #eMMC size
    echo -e "\nReady to print eMMC size ... "
    adb.exe shell cat /sys/bus/mmc/devices/mmc0\:0001/block/mmcblk0/size
    #eMMC Manufacture ID
    echo -e "\nReady to print eMMC Manufacture ID ... "
    adb.exe shell  cat /sys/bus/mmc/devices/mmc0\:0001/manfid
}

#Check DDR size, DDR ID
function menu_option_7(){
    #Check DDR size
    echo -e "\nReady to Check DDR size ... "
    adb.exe shell "cat /proc/meminfo | awk '/MemTotal/{print $2}'"
    #Check DDR ID
    echo -e "\nReady to Check DDR ID ... "
    adb.exe shell "cat /proc/cmdline | awk 'BEGIN{RS=\" \"; FS=\"=\"} /ddr_id/{print $2}'"
}

#Check PMIC information
function menu_option_8(){
    echo -e "\nReady to Check PMIC information ... "
    adb.exe shell "echo 100 > /sys/bus/platform/devices/mt6397-pmic/pmic_access;
    cat /sys/bus/platform/devices/mt6397-pmic/pmic_access"
}

#Check ID
function menu_option_9(){
    echo -e "\nReady to Check ID ... "
    adb.exe shell "i2cget -f -y 4 0x6b 0x0F"
}

#Power button
function menu_option_10(){
    echo -e "\nReady to Power Button ... "
    adb.exe root
    adb.exe wait-for-device
    adb.exe remount
    adb.exe wait-for-device
    adb.exe shell "timeout 10 sh /vendor/etc/power_key_test.sh; killall -9 getevent"
}

#4 top cover buttons
function menu_option_11(){
    echo -e "\nReady to 4 top cover buttons ... "
    adb.exe root
    adb.exe shell "for n in 119 122 123 124; do  echo mode $n 0 > /sys/bus/platform/devices/1000b000.pinctrl/mt_gpio;\
    echo dir $n 0 > /sys/bus/platform/devices/1000b000.pinctrl/mt_gpio; done"
    adb.exe shell "cat /sys/bus/platform/devices/1000b000.pinctrl/mt_gpio | grep 119"
    adb.exe shell "cat /sys/bus/platform/devices/1000b000.pinctrl/mt_gpio | grep 122"
    adb.exe shell "cat /sys/bus/platform/devices/1000b000.pinctrl/mt_gpio | grep 123"
    adb.exe shell "cat /sys/bus/platform/devices/1000b000.pinctrl/mt_gpio | grep 124"
}
#LED option
function menu_option_12(){

    local LED_onoff
    local LED_num
    local LED_color

    while [ 1 ]
    do
	#Select LED number
	menu_LED_num_show
        read -p ": " LED_num
	check_out_of_index ${LED_num} 0 4
	[[ $? != 0 || ${LED_num} == 0 ]] && break;
    	[[ ${LED_num} == 1 ]] && LED_num='/sys/bus/i2c/drivers/ktd202x/2-0031/'
	[[ ${LED_num} == 2 ]] && LED_num='/sys/bus/i2c/drivers/ktd202x/3-0030/'
	[[ ${LED_num} == 3 ]] && LED_num='/sys/bus/i2c/drivers/ktd202x/3-0031/'
	[[ ${LED_num} == 4 ]] && LED_alloff && break
	
	#Select LED color
	menu_LED_color_show
	read -p ": " LED_color
	check_out_of_index ${LED_color} 0 3
	[[ $? != 0 || ${LED_color} == 0 ]] && break
	LED_color="ch${LED_color}_enable"
	
	#Select LED on or off
	menu_LED_onoff_show
	read -p ": " LED_onoff
	check_out_of_index ${LED_onoff} 0 1
	[[ $? != 0 ]] && break
	LED_onoff="echo ${LED_onoff}"

	adb.exe shell "${LED_onoff} > ${LED_num}${LED_color}"
    done
}

function LED_alloff(){
    adb.exe shell "echo 1 > /sys/bus/i2c/drivers/ktd202x/2-0031/reset"
    adb.exe shell "echo 1 > /sys/bus/i2c/drivers/ktd202x/3-0030/reset"
    adb.exe shell "echo 1 > /sys/bus/i2c/drivers/ktd202x/3-0031/reset"
}

function menu_option_13(){
    echo -e "\nReady to MIC1/MIC2 record ... "
    adb.exe root
    adb.exe shell "tinymix 'Stereo1 DMIC Mux' 'DMIC1'"
    adb.exe shell "tinymix 'Stereo1 ADC L2 Mux' 'DMIC'"
    adb.exe shell "tinymix 'Stereo1 ADC R2 Mux' 'DMIC'"
    adb.exe shell "tinymix 'Stereo1 ADC MIXL ADC2 Switch' 1"
    adb.exe shell "tinymix 'Stereo1 ADC MIXR ADC2 Switch' 1"
    adb.exe shell "tinymix 'STO1 ADC Capture Volume' 100"
    adb.exe shell  "tinycap /sdcard/m2_dmic.wav -d 8 -c 2 -r 48000 -T 6"
    adb.exe pull /sdcard/m2_dmic.wav ~/m2_dmic.wav
}

#Check MB/CB Thermal sensor temperature
function menu_option_14(){
    echo -e "\nReady to Check MB Thermal sensor temperature ... "
    adb.exe shell cat /sys/bus/i2c/drivers/tmp103_temp_sensor/4-0070/temp1_input
    echo -e "\nReady to Check CB Thermal sensor temperature ... "
    adb.exe shell cat /sys/bus/i2c/drivers/tmp103_temp_sensor/2-0070/temp1_input
}

#Start the program
check_adb_devices && adb.exe root || return 1
while [ 1 ]
do
    menu_show
    read -p 'Enter your option or 0 to Exit and press Enter:' user_choice
    check_out_of_index ${user_choice} 0 14
    [[ $? != 0 ]] && continue
    if [[ ${user_choice} == 0 ]];then
	break
    else
        menu_option_${user_choice}
    fi
done
